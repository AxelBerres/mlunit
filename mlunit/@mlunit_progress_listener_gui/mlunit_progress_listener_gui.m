%GUI progress listener implementation.
%  Displays test results live in the GUI as they are being executed.
%  Is instanciated with handles of the graphical GUI objects it needs to update.
%  Also stores internal states, e.g. how many tests have been run so far. You
%  therefore are advised to keep the instance variable around and up to date.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_progress_listener_gui(progress_bar, text_runs, error_listbox)

mlunit_narginchk(3, 3, nargin);

self = struct();
self.progress_bar = progress_bar;
self.text_runs = text_runs;
self.error_listbox = error_listbox;

% init these so the instanciates knows of their fieldnames
self.max_num_results = 0;
self.num_results = 0;
self.num_errors = 0;
self.num_failures = 0;
self.num_skipped = 0;

self = class(self, 'mlunit_progress_listener_gui', mlunit_progress_listener);

self = init_results(self, 0);
reset_progress_bar(self);
reset_texts(self);


function reset_progress_bar(self)

    barh(1, 1, 'FaceColor', [1 1 1]);
    set(self.progress_bar, 'XLim', [0 1]);
    set(self.progress_bar, 'YLim', [0.6 1.4]);
    set(self.progress_bar, 'XTick', [], 'XTickLabel', []);
    set(self.progress_bar, 'YTick', [], 'YTickLabel', []);
    drawnow;

    
function reset_texts(self)

    set(self.text_runs, 'String', ['Runs: 0', ...
        ' / Errors: 0', ...
        ' / Failures: 0']);
