function names = get_subfunction_names(self, filename) %#ok<INUSL>
%Parse a MATLAB file and return all subfunction names.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

mlunit_narginchk(2,2,nargin);

str = textread(filename, '%s', 'whitespace', '', 'delimiter', '\n' );
idx = regexp(str, '^\s*function\s+\w*', 'start');
is_func = not(cellfun('isempty', idx));

% remove very first function item, which should be the host function
is_func(find(is_func, 1)) = 0;

tokens = transpose(regexp(str(is_func),...
    '^\s*function\s+([\]\[,_a-zA-Z0-9 ]+=\s*)?(\w*)\s*\%*.*',...
    'tokens'));

% cell-unwrap tokens twice, as regexp nests its content in a 3-level cell array
names = {};
if ~isempty(tokens)
    first = @(c)c{1};
    second = @(c)c{2};
    names = cellfun(second, cellfun(first, tokens, 'UniformOutput', false), 'UniformOutput', false);
end
