%Obtain the function handle to a subfunction.
%
%  The subfunction is referenced by the name of the file it contains, and its
%  subfunction name. The file must be a function file on the MATLAB path and
%  must contain a local function/subfunction by the given name.
%  The local function must not be a nested function.
%
%  The handle is obtained by spoofing a serialization byte stream and
%  deserializing it. The byte stream format is described officially [1].
%  The deserialization routine is available as C function mxDeserialize defined
%  in mex.h. From R2011b onwards, there is an undocumented deserialization
%  command available from the MATLAB console: getArrayFromByteStream.
%  See also [2].
%  
%  Compatibility: R2011b and newer, especially R2015b and R2016b. Will not work
%  on releases older than R2011b, due to lack of getArrayFromByteStream.
%
%  [1] https://www.mathworks.com/help/pdf_doc/matlab/matfile_format.pdf
%  [2] http://undocumentedmatlab.com/blog/serializing-deserializing-matlab-data

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function handle = mlunit_get_subfunction_handle(filename, subfunc_name)
    mlunit_narginchk(2,2,nargin);
    
    fullpath = which(filename);
    % if which did not find a thing, treat as absolute, maybe imaginative, path
    if isempty(fullpath), fullpath = filename; end
    % extract function name
    [dummy, func_name] = fileparts(filename);
    
    bs = bytestream_container(fullpath,func_name,subfunc_name);
    
    try
        % getArrayFromByteStream only available from R2011b on
        if 5 == exist('getArrayFromByteStream', 'builtin')
           handle = getArrayFromByteStream(bs);
        % got to use C interface for releases older than R2011b
        else
           handle = deserialize(bs);
        end
    catch me
        if strcmp('MATLAB:dispatcher:UnableToResolveHiddenFunction', me.identifier)
            handle = [];
        else
            rethrow(me);
        end
    end
end

function bs = bytestream_container(fullpath, func_name, subfunc_name)
    % A byte stream container consists of a magic string, a header,
    % including the whole container's size, and a data type container.
    
    magic = bytes([1296630016, 0]);
    
    type_info = bytes([6, 8, 16, 0, 5, 8, 1, 1, 1, 0]);
    
    section = datatype_container(fullpath, func_name, subfunc_name);
    
    content = [type_info, section];
    
    header = bytes([14, numel(content)]);
    
    bs = [magic, header, content];
end

function bs = datatype_container(fullpath, func_name, subfunc_name)
    % A data type container consists of a header, including the whole
    % container's size, an index, containing strings denominating 4 sections,
    % and the 4 sections. Of the 4 sections, one is a string sections, 2 are
    % single character sections, and one is a function handle container.

    type_info = bytes([6, 8, 2, 0, 5, 8, 1, 1, 1, 0]);
    
    section_names = {'matlabroot', 'separator', 'sentinel', 'function_handle'};
    section_items_cell = cellfun(@(t)pad(t,16), section_names, 'UniformOutput', false);
    section_items = [section_items_cell{:}];
    index = [bytes([262149, 16, 1, numel(section_items)]), section_items];
    
    sec1 = string_section(matlabroot);      % matlabroot
    sec2 = char_section(filesep);           % separator
    sec3 = char_section('@');               % sentinel
    sec4 = functionhandle_container(fullpath, func_name, subfunc_name); % function_handle
    
    content = [type_info, index, sec1, sec2, sec3, sec4];
    
    header = bytes([14, numel(content)]);
    
    bs = [header, content];
end

function bs = functionhandle_container(fullpath, func_name, subfunc_name)
    % A function handle container consists of a header, including the whole
    % container's size, an index, containing strings denominating 4 sections,
    % and the 4 sections. Of the 4 sections, 3 are string sections, and one is
    % a parentage_container.
    
    type_info = bytes([6, 8, 2, 0, 5, 8, 1, 1, 1, 0]);
    
    section_names = {'function', 'type', 'file', 'parentage'};
    section_items_cell = cellfun(@(t)pad(t,10), section_names, 'UniformOutput', false);
    section_items = [section_items_cell{:}];
    index = [bytes([262149, 10, 1, numel(section_items)]), section_items];

    sec1 = string_section(subfunc_name);        % function
    sec2 = string_section('scopedfunction');    % type
    sec3 = string_section(fullpath);            % file
    sec4 = parentage_container(func_name, subfunc_name);    % parentage
    
    content = [type_info, index, sec1, sec2, sec3, sec4];
    
    header = bytes([14, numel(content)]);
    
    bs = [header, content];
end

function bs = parentage_container(func_name, subfunc_name)
    % A parentage container consists of a header, including the whole
    % container's size, and two string sections: one containing the subfunction
    % name, one containing the function/file name
    
    type_info = bytes([6, 8, 1, 0, 5, 8, 1, 2, 1, 0]);
    sec1 = string_section(subfunc_name);
    sec2 = string_section(func_name);
    
    content = [type_info, sec1, sec2];
    
    header = bytes([14, numel(content)]);
        
    bs = [header, content];
end

function bs = string_section(text)
    
    assert(isvector(text));

    len = numel(text);
    type_info = bytes([6, 8, 4, 0, 5, 8, 1, len, 1, 0, 16, len]);
    
    % pad text onto full 8 byte segments
    content = [type_info, pad(text, 8)];

    header = bytes([14, numel(content)]);
    
    bs = [header, content];
end

function bs = char_section(character)
    
    assert(isscalar(character));

    type_info = bytes([6, 8, 4, 0, 5, 8, 1, 1, 1, 0]);
    
    % pad text onto full 8 byte segments
    content = [type_info, bytes(1*2^16 + 16), bytes(character)];

    header = bytes([14, numel(content)]);
    
    bs = [header, content];
end

% Treat num as unsigned 32bit integer and output as an array of 4 uint8s.
% Converts to system's endianness. num can be an array of uint32s.
function bs = bytes(nums)
    bs = typecast(uint32(nums), 'uint8');
end

% Pad text onto full n byte segments.
function bs = pad(text, n)
    assert(isempty(text) || isvector(text));
    len = numel(text);
    padded_length = n*ceil(len/n);
    padding = zeros(1, padded_length-len, 'uint8');
    bs = [uint8(text), padding];
end
