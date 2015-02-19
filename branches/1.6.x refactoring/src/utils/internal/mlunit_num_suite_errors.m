%MLUNIT_STRJOIN Concatenate a string cell's items, using a separator.
%  S=MLUNIT_STRJOIN(C,SEP) yields the single string S: the concatenation of all of the
%  items from string cell C. Every two items are joined with the separator SEP.
%  SEP defaults to ', '.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function num_errors = mlunit_num_suite_errors(results)

error(nargchk(1, 1, nargin, 'struct'));

num_errors = sum(arrayfun(@(e) all(~isempty(e.errors)), results));