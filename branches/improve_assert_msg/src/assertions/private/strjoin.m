function result = strjoin(stringcell, separator)
%STRJOIN Concatenate a string cell's items, using a separator.
%  S=STRJOIN(C,SEP) yields the single string S: the concatenation of all of the
%  items from string cell C. Every two items are joined with the separator SEP.
%  SEP defaults to ', '.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 1, stringcell = {}; end
if nargin < 2, separator = ', '; end
if isempty(stringcell), result = ''; return; end
result = [sprintf(['%s' separator], stringcell{1:end-1}), stringcell{end}];
