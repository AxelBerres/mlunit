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

% TODO: Caption: "GUI quality-of-life updates"

% TODO: Improvements
% - Make message more prominent and distinguish it from the stack trace
% - Improve data handling in GUI.
% - On Run, put keyboard focus into error list
% - In error list, perform "Show" upon Enter.

% TODO: New Features
% - file/directory selector dialog button. Just a thin button called "...", or with a
%   directory icon.
% - save a recently used list instead of just the last item. As a dropdown menu when
%   clicking on the edit field or pressing the down key.
% - Support for docking is nice.
%   But the functionality is hidden. Can we make it visible somehow?

% TODO: Probably Not Possible
% - make error output selectable and copyable, but still not editable
%   However, registering the figure's WindowButtonDownFcn can mask the edit field
%   and copy on click. Question is how to make the user recognize that happened.
%   Tooltip? "Click to copy"
% - Fix awkward wrap behaviour for running '1'. Fiddle with Max and Min parameters!
%   Try inputting different formats: char vector, char matrix, cellstr, string array

% TODO: Non-GUI Features
% - In case of suite_set_up or suite_tear_down errors, don't introduce new results,
%   but add errors to single test results.



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
