%GUI progress listener implementation.
%  Displays test results live in the GUI as they are being executed.
%  Is instanciated with handles of the graphical GUI objects it needs to update.
%  Also stores internal states, e.g. how many tests have been run so far. You
%  therefore are advised to keep the instance variable around and up to date.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = mlunit_progress_listener_gui(progress_bar, text_runs, error_listbox, text_time)

mlunit_narginchk(4, 4, nargin);

self = struct();
self.progress_bar = progress_bar;
self.text_runs = text_runs;
self.error_listbox = error_listbox;
self.text_time = text_time;

% init these so the instanciates knows of their fieldnames
self.max_num_suites = 0;
self.max_num_results = 0;
self.num_suites = 0;
self.current_suite = '';
self.num_results = 0;
self.num_all_results = 0;
self.num_errors = 0;
self.num_failures = 0;
self.num_skipped = 0;

self = class(self, 'mlunit_progress_listener_gui', mlunit_progress_listener);
reset_display(self, 0);
