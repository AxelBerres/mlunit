%Begin listening to incoming suites.
%  SELF = INIT_SUITES(SELF, MAXNUM) tells the listener to prepare herself for
%  subsequent next_suite calls. There will be exactly MAXNUM next_suite calls
%  for this run, each providing the name of the next pending test suite.
%
%  This method is provided by the user, but should not be called by her.
%
%  See also next_suite

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = init_suites(self, num_suites)

mlunit_narginchk(2, 2, nargin);
if ~isnumeric(num_suites) || numel(num_suites)~=1, error('num_suites argument need be scalar numeric'); end

% reset all values
self.max_num_suites = num_suites;
self.max_num_results = 0;
self.num_suites = 0;
self.num_results = 0;
self.num_errors = 0;
self.num_failures = 0;
self.num_skipped = 0;

reset_display(self, num_suites);
update_display(self);
