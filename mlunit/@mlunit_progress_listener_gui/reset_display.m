%GUI progress listener implementation.
%  Displays test results live in the GUI as they are being executed.
%  Is instanciated with handles of the graphical GUI objects it needs to update.
%  Also stores internal states, e.g. how many tests have been run so far. You
%  therefore are advised to keep the instance variable around and up to date.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = reset_display(self, num_progress_suites)

mlunit_narginchk(2, 2, nargin);

reset_progress_bar(self, num_progress_suites);
reset_texts(self);

% reset error list entries
set(self.error_listbox, 'String', {});
set(self.error_listbox, 'UserData', {});
% auto-select no item
set(self.error_listbox, 'Value', 0);


function reset_progress_bar(self, num_progress_suites)

    xlimit = max(1, num_progress_suites);
    barh(self.progress_bar, 1, xlimit, 'FaceColor', [1 1 1]);
    set(self.progress_bar, 'XLim', [0 xlimit]);
    set(self.progress_bar, 'YLim', [0.6 1.4]);
    set(self.progress_bar, 'XTick', [], 'XTickLabel', []);
    set(self.progress_bar, 'YTick', [], 'YTickLabel', []);
    drawnow;

    
function reset_texts(self)

    set(self.text_runs, 'String', ['Runs: 0', ...
        ' / Errors: 0', ...
        ' / Failures: 0']);
