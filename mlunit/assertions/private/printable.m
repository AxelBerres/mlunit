function outstring = printable(input)
%PRINTABLE Convert any type into a string suitable for embedding into messages.
%  S=PRINTABLE(V) yields a message printable string from value V of any type.
%  Message printable means strings being surrounded by apostrophes, vectors by
%  rectangle parentheses, scalar numerics by nothing, and so on. Leaves numerics
%  and otherwise unknown types to mat2str.
%
%  Cell and struct arrays will be linearized.
%
%  PRINTABLE should probably only be called on small values, so that the result
%  does not span multiple lines. When converting class objects, however, a
%  multi-line output will be generated nonetheless.
%
%  See also MAT2STR, mat2str_char, isclass

%  This Software and all associated files are released unter the
%  GNU General Public License (GPL), see LICENSE for details.

if nargin < 1
    outstring = '';
elseif ischar(input) && isempty(input)
    % mat2str blunders when being given a 1x0 char and returns logical instead.
    % We also need to make sure to preserve the size (0x0 vs 1x0) of the input.
    % We return the empty string (''). Don't need the previous size information.
    outstring = '''''';
elseif ischar(input) && ndims(input) <= 2
    % On R2006b, mat2str prints strings awkwardly. Enforce new style:
    % ['foo';'bar'] for character arrays, 'foobar' for single strings
    % Only works on char arrays with ndims<=2, as mat2str does, BTW.
    outstring = mat2str_char(input);
elseif (isnumeric(input) || isstring(input)) && isempty(input)
    % mat2str likes to translate empty numericals into strings like 'zeros(0,1)'
    % except no one put any zeroes there. Why do we rely on mat2str at all?
    outstring = '[]';
elseif iscell(input)
    items = cell(size(input));
    for i=1:numel(input)
        items{i} = printable(input{i});
    end

    if numel(items) > 0
        % Linearize all dimensions but the second. That way, we lose some structure
        % information for 3D cell matrices, but at least include their content.
        % It's difficult to walk over everything but the second dimension
        % in a general manner in MATLAB, but here you go:
        outerSize = size(items);
        outerSize(2) = [];
        outerLength = numel(items) / size(items, 2); % same as prod(outerSize)
        outerItems = cell(outerLength, 1);
        for idxOuter = 1:outerLength
            [dim1st, dimOthers] = ind2sub(outerSize, idxOuter);
            outerItems{idxOuter} = mlunit_strjoin(items(dim1st, :, dimOthers));
        end
        outstring = ['{' mlunit_strjoin(outerItems, '; ') '}'];
    else
        outstring = '{}';
    end
elseif isstruct(input)
    print_scalar_struct = @(s) ['{' mlunit_strjoin(fieldname_value_strings(s), '; ') '}'];
    items = arrayfun(print_scalar_struct, input, 'UniformOutput', false);
    outstring = ['[' mlunit_strjoin(items) ']'];
elseif isclass(input)
    outstring = loc_getClassDisplay(input);
elseif isa(input, 'function_handle')
    outstring = func2str(input);
elseif isjava(input)
    % toString returns a java.lang.String which we need to return as native char
    outstring = char(input.toString());
else
    % mat2str takes care of everything else or throws an error
    outstring = mat2str(input);
end

outstring = loc_trim_empty_lines(outstring);


% Works on a scalar structure only.
function fieldstrings = fieldname_value_strings(s)

    name_value_pair = @(fieldname) [fieldname ':' printable(s.(fieldname))];
    fieldstrings = cellfun(name_value_pair, fieldnames(s), 'UniformOutput', false);

% Some meaningful string representation of any class
function outstring = loc_getClassDisplay(classinstance) %#ok<INUSD>
    % use what MATLAB shows when we prompt for some object
    % output is class dependent and has no common access other than the cmd line
    outstring = evalc('classinstance');

% Strip empty lines from the beginning and the end of a multi-line string.
% Was once done with a simple regular expression, but was switched to explicit
% looping in order to improve runtime performance.
function out = loc_trim_empty_lines(in)

    whitespace = char([32, 9, 10]); % space, tab, newline

    front = 1;
    back = length(in);
    while front <= back && any(in(front) == whitespace)
        front = front + 1;
    end
    while back >= front && any(in(back) == whitespace)
        back = back - 1;
    end

    out = in(front:back);
