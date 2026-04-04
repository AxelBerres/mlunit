%Update all listener elements of the GUI.
%  update_display(SELF) updates the GUI elements that need updating after
%  getting another test result. SELF is an mlunit_progress_listener_gui instance.
%
%  This is an mlunit_progress_listener_gui internal method and should not be called from
%  the outside.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function update_display(self)

update_progress_bar(self);
texts(self);
drawnow;

% TODO: render quicker
%   About 4s for D:\repos\mlunit\test\utils in GUI
%   About 2s for D:\repos\mlunit\test\utils in Console
%   That's 2s overhead for 60 updates.
% TODO: disable Run button
% TODO: fix Show button
% TODO: make error output selectable and copyable

function update_progress_bar(self)

    % make progress bar current axis/object
    %axes(self.progress_bar);
    
    % choose color
    if self.num_suites == 0
        color = [1 1 1]; % white
    elseif self.num_errors > 0 || self.num_failures > 0
        color = [1 0 0]; % red
    else
        color = [0 1 0]; % green
    end
    
    % draw bar
    barh(self.progress_bar, 1, self.num_suites - 1 + (self.num_results/self.max_num_results), 'FaceColor', color);

    xlimit = max(1, self.max_num_suites);
    set(self.progress_bar, 'XLim', [0 xlimit]);
    set(self.progress_bar, 'YLim', [0.6 1.4]);
    set(self.progress_bar, 'XTick', [], 'XTickLabel', []);
    set(self.progress_bar, 'YTick', [], 'YTickLabel', []);

    
function texts(self)

    set(self.text_runs, 'String', ['Tests: ', num2str(self.num_all_results), ...
        ' / Errors: ', num2str(self.num_errors), ...
        ' / Failures: ', num2str(self.num_failures), ...
        ' / Skipped: ', num2str(self.num_skipped)]);
