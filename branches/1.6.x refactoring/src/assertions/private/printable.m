function outstring = printable(input)
%PRINTABLE Convert any type into a string suitable for embedding into messages.
%  S=PRINTABLE(V) yields a message printable string from value V of any type.
%  Message printable means strings being surrounded by apostrophes, vectors by
%  rectangle parentheses, scalar numerics by nothing, and so on. Leaves most of
%  the heavy lifting to mat2str.
%
%  Cell and struct arrays will be linearized.
%
%  PRINTABLE should probably only be called on small values, so that the result
%  does not span multiple lines.
%
%  See also MAT2STR

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 1
    outstring = '';
elseif iscell(input)
    items = cellfun(@printable, input, 'UniformOutput', false);
    % linearizes the cell array's matrix structure
    outstring = ['{' strjoin(items) '}'];
elseif isstruct(input)
    print_scalar_struct = @(s) ['{' strjoin(fieldname_value_strings(s), '; ') '}'];
    items = arrayfun(print_scalar_struct, input, 'UniformOutput', false);
    outstring = ['[' strjoin(items) ']'];
elseif ischar(input) && isempty(input)
    % mat2str blunders when being given a 1x0 char and returns logical instead.
    % We also need to make sure to preserve the size (0x0 vs 1x0) of the input.
    outstring = ['''' input ''''];
elseif ischar(input) && ndims(input) <= 2
    % On R2006b, mat2str prints strings awkwardly. Enforce new style:
    % ['foo';'bar'] for character arrays, 'foobar' for single strings
    % Only works on char arrays with ndims<=2, as mat2str does, BTW.
    outstring = mat2str_char(input);
else
    % mat2str takes care of everything else or throws an error
    outstring = mat2str(input);
end


% Works on a scalar structure only.
function fieldstrings = fieldname_value_strings(s)

    name_value_pair = @(fieldname) [fieldname ':' printable(s.(fieldname))];
    fieldstrings = cellfun(name_value_pair, fieldnames(s), 'UniformOutput', false);
