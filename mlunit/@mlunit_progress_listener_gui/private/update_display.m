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

persistent isR2015bOrNewer
if isempty(isR2015bOrNewer)
    isR2015bOrNewer = ~verLessThan('matlab', '8.6');
end

update_progress_bar(self);
texts(self);

% Force MATLAB to draw now.
% Draw precisely for the first two and last two suites,
% so that the user perceives progress, even when running just a few tests.
% Skimp on in-between results by using limitrate to reduce drawing overhead
% for runs that have many results.
% Older MATLABs than R2015b cannot optimize here without sacrificing callbacks.
if isR2015bOrNewer && ...
        self.num_suites > 2 && ...
        self.num_suites <= self.max_num_suites - 2
    % limited redraw
    drawnow('limitrate');
else
    drawnow();
end

% Caption: "GUI quality-of-life updates"

% TODO: Non-GUI
% - Make clear that some mlunit_param entries are console output only
% - Structure latest CHANGES entry.
% - Remove this list.

% Shelved for now
% - Rerun single suites by right-click in the error list
% - Improve data handling in GUI.
% - remember dialog size if not docked
% - save a recently used list instead of just the last item. As a dropdown menu when
%   clicking on the edit field or pressing the down key. Dropdown ui element uidropdown is
%   available only from R2016a.
% - Support for docking is nice.
%   But the functionality is hidden. Can we make it visible somehow?

% Known Issues
% - When changing the error item during a test run, the mlUnit GUI may be in a drawnow
%   call and thereby reset the selection to the previous state.
% - Awkward wrap behaviour for long texts. If a long line wraps, short lines do, too.
%   R2011b ok, R2013b ok, R2015b bad, R2019b bad, R2024b bad, R2025b ok
%   Finally fixed this 10 year bug.
% - No file/directory selector button. 
%   MATLAB can only choose a directory OR a file, not any/both with the same dialog.
%   Also, users are currently expected to manage their test paths themselves,
%   or run a whole directory. With specific files, additional logic would be needed
%   adding them to the path or for changing dirs so that the files become visible.
%   Further, the edit box content could get very long; normally it should be flush left,
%   but on long input the interesting bit is on the right. This all plays out very poorly.

% Non-GUI Features
% - In case of suite_set_up or suite_tear_down errors, don't introduce new results,
%   but add errors to single test results.


function update_progress_bar(self)

    % choose color
    if self.num_suites == 0
        color = [1 1 1]; % white
    elseif self.num_errors > 0 || self.num_failures > 0
        color = [1 0 0]; % red
    else
        color = [0 1 0]; % green
    end
    
    % calculate bar position
    if self.num_suites == 0
        position = 0;
    else
        position = self.num_suites - 1 + (self.num_results/self.max_num_results);
    end
    
    % update bar
    graphicObjects = get(self.progress_bar, 'Children');
    if ~isempty(graphicObjects)
        % first object is the resizing progress rectangle
        rect = graphicObjects(1);
        
        set(rect, 'XData', [0 position position 0]);
        set(rect, 'FaceColor', color);
    end

    
function texts(self)

    set(self.text_runs, 'String', ['Tests: ', num2str(self.num_all_results), ...
        ' / Errors: ', num2str(self.num_errors), ...
        ' / Failures: ', num2str(self.num_failures), ...
        ' / Skipped: ', num2str(self.num_skipped)]);
