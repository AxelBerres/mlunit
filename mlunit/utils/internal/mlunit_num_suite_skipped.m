%Count the number of skipped tests in a suite's results.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function num_skipped = mlunit_num_suite_skipped(results)

mlunit_narginchk(1, 1, nargin);

num_skipped = sum(arrayfun(@(e) ~isempty(e.skipped), results));
