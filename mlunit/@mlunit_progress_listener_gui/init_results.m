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
%  
%  $Id$

function self = init_results(self, maxnum)

mlunit_narginchk(2, 2, nargin);
if ~isnumeric(maxnum) || numel(maxnum)~=1, error('maxnum argument need be scalar numeric'); end

% reset error list entries
set(self.error_listbox, 'String', {});
set(self.error_listbox, 'UserData', {});
% auto-select no item
set(self.error_listbox, 'Value', 0);

% no tests run yet
self.num_results = 0;
self.num_errors = 0;
self.num_failures = 0;
self.num_skipped = 0;

self.max_num_results = maxnum;

update_display(self);
