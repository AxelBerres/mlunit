%Provide a random quip.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function quip = random_quip()

% Buffer quip list, so that it doesn't need to be read on each and every call.
persistent quip_list

if isempty(quip_list)
    quip_list = load_quips();
end

num_quips = numel(quip_list);
index = floor(rand()*num_quips + 1);
quip = quip_list{index};


function quip_list = load_quips()

    parentdir = fileparts(mfilename('fullpath'));
    quipfile = fullfile(parentdir, 'quips.txt');
    
    % Read UTF-8 file into a single string.
    fid = fopen(quipfile, 'r', 'n', 'UTF-8');
    cleanupHandle = onCleanup(@()fclose(fid));
    content = fread(fid, [1 inf], '*char');
    clear cleanupHandle
    
    % Normalize newlines for display.
    content = strrep(content, sprintf('\r\n'), sprintf('\n')); %#ok<SPRINTFN>
    
    % Split on blank lines.
    quip_list = regexp(content, '\n\n', 'split');
