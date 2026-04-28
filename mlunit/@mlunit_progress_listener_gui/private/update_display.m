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
