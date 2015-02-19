%MLUNIT_STRJOIN Concatenate a string cell's items, using a separator.
%  S=MLUNIT_STRJOIN(C,SEP) yields the single string S: the concatenation of all of the
%  items from string cell C. Every two items are joined with the separator SEP.
%  SEP defaults to ', '.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function num_failures = mlunit_num_suite_failures(results)

error(nargchk(1, 1, nargin, 'struct'));

num_failures = sum(arrayfun(@(e) ~isempty(e.failure), results));
