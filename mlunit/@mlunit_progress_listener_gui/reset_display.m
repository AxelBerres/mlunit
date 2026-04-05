%GUI progress listener implementation.
%  Displays test results live in the GUI as they are being executed.
%  Is instanciated with handles of the graphical GUI objects it needs to update.
%  Also stores internal states, e.g. how many tests have been run so far. You
%  therefore are advised to keep the instance variable around and up to date.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function reset_display(self, num_progress_suites)

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
    
    graphicObjects = get(self.progress_bar, 'Children');
    if isempty(graphicObjects)
        % The actually moving part of the progress bar is just a rectangle
        rect = patch( ...                   % draw a rectangle
            [0 xlimit xlimit 0], ...        % x values of vertices
            [0.6 0.6 1.4 1.4], ...          % y values of vertices
            [1 1 1], ...                    % color
            'Parent', self.progress_bar);   % embed in parent

        isR2015bOrNewer = ~verLessThan('matlab', '8.6');
        if isR2015bOrNewer
            % prevent blurry lines
            set(rect, 'AlignVertexCenters', 'on');
        end
    end

    % set display area
    set(self.progress_bar, 'XLim', [0 xlimit]);
    set(self.progress_bar, 'YLim', [0.6 1.4]);
    
    % remove axis ticks and labels
    set(self.progress_bar, 'XTick', [], 'XTickLabel', []);
    set(self.progress_bar, 'YTick', [], 'YTickLabel', []);
    
    drawnow;

    
function reset_texts(self)

    set(self.text_runs, 'String', ['Runs: 0', ...
        ' / Errors: 0', ...
        ' / Failures: 0']);
