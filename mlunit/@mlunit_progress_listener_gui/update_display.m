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

% Force MATLAB to draw now.
% Draw precisely for the first two and last two suites,
% so that the user perceives progress, even when running just a few tests.
% Skimp on in-between results by using limitrate to reduce drawing overhead
% for runs that have many results.
if self.num_suites > 2 && self.num_suites <= self.max_num_suites - 2
    drawnow('limitrate', 'nocallbacks');
else
    drawnow('nocallbacks');
end

% TODO: disable Run button
% TODO: make error output selectable and copyable
% TODO: maintain a recently used list somehow
% TODO: anything possible about that GUI test itself?
% TODO: Make message more prominent and distinguish it from the stack trace
% TODO: Fix awkward wrap behaviour for running '1'
% TODO: reenable saving mechanism?
% TODO: The shorten directory names mechanism eats white space. Fix it or drop it.
% TODO: Support docked any more? Yes, do we need it? Yes, it's nice.
%       But the functionality is hidden. Can we make it visible somehow?

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
