%Count the number of errors in a suite's results.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function num_errors = mlunit_num_suite_errors(results)

mlunit_narginchk(1, 1, nargin);

num_errors = sum(arrayfun(@(e) all(~isempty(e.errors)), results));
