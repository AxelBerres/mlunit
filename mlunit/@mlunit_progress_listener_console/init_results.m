%Begin listening to incoming results.
%  SELF = INIT_RESULTS(SELF, MAXNUM) tells the listener to prepare herself for
%  subsequent next_result calls. There will be exactly MAXNUM next_result calls
%  for this run, each providing the result of one test case execution.
%
%  This method is provided by the user, but should not be called by her.
%
%  See also next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = init_results(self, maxnum)

mlunit_narginchk(2, 2, nargin);
if ~isnumeric(maxnum) || numel(maxnum)~=1, error('maxnum argument need be scalar numeric'); end

self.has_preceding_detailed_output = false;
