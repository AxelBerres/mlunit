function result = mlunit_strjoin(stringcell, separator)
%MLUNIT_STRJOIN Concatenate a string cell's items, using a separator.
%  S=MLUNIT_STRJOIN(C,SEP) yields the single string S: the concatenation of all of the
%  items from string cell C. Every two items are joined with the separator SEP.
%  SEP defaults to ', '.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

if nargin < 1, stringcell = {}; end
if nargin < 2, separator = ', '; end

if ~iscellstr(stringcell), error('stringcell need be cellstr'); end
if ~ischar(separator), error('separator need be char'); end

if isempty(stringcell), result = ''; return; end
result = [sprintf(['%s' separator], stringcell{1:end-1}), stringcell{end}];

% The sprintf statement may produce 1x0 or 0x0 empty results, which MATLAB
% does not see as being equal. Normalize to 0x0.
if isempty(result)
   result = '';
end
