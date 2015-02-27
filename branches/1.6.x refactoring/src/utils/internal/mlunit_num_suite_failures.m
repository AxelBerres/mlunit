%Count the number of failures in a suite's results.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function num_failures = mlunit_num_suite_failures(results)

error(nargchk(1, 1, nargin, 'struct'));

num_failures = sum(arrayfun(@(e) ~isempty(e.failure), results));
