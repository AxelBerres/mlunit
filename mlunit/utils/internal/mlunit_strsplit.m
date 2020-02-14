function result = mlunit_strsplit(text, separator)
%MLUNIT_STRSPLIT Split a string at all occurences of a delimiting string.
%  C=MLUNIT_STRSPLIT(T,SEP) yields the cell array of strings C, containing
%  the parts of input text T that are separated by SEP.
%  SEP defaults to ','.
%  C will contain empty items, if T contains two separators immediately
%  after one another, or if T start or ends on a separator.
%
%  Examples
%
%     % returns {'a', 'b', 'c'}
%     c = mlunit_strsplit('a,b,c');
%
%     % returns {'', 'f', 'bar', 'da'}
%     c = mlunit_strsplit('oofoobarooda', 'oo');

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin < 1, result = {}; return; end
if nargin < 2, separator = ','; end

if ~ischar(text), error('text need be char'); end
if ~ischar(separator), error('separator need be char'); end

result = {};
separator_length = numel(separator);
indices = [1-separator_length, strfind(text, separator), numel(text)+1];
for i = 1:numel(indices)-1
    result{i} = text(indices(i)+separator_length : indices(i+1)-1);
    % normalize empty strings to 0x0 instead of 1x0 or some such
    if isempty(result{i})
       result{i} = '';
    end
end
