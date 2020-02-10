function result = mlunit_strsplit(text, separator)
%MLUNIT_STRJOIN Concatenate a string cell's items, using a separator.
%  S=MLUNIT_STRJOIN(C,SEP) yields the single string S: the concatenation of all of the
%  items from string cell C. Every two items are joined with the separator SEP.
%  SEP defaults to ', '.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

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
