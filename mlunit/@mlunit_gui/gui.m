function varargout = gui(object, varargin)
%mlunit_gui/gui execute the graphical user interface of mlUnit.
%  The graphical user interface is realized with guide and therefore
%  a file gui.fig exists containing the figure and all the handles.
%
%  Example
%  =======
%  Start the mlunit_gui:
%         gui(mlunit_gui);
%
%  See also GUI_TEST_RESULT, mlunit_gui.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  Author: Thomas Dohmke <thomas@dohmke.de>

global self;

if ((object.callback ~= 1) && (isempty(self) || (isempty(get_object(self)))))
    self = object;
elseif ((object.callback == 1) && (isempty(self)))
    handles = guidata(gcbo);
    try
        self = builtin('get', handles.mlunit_gui_window, 'UserData');
    catch
    end
end

gui_singleton = 1;
gui_state = struct('gui_Name', mfilename, ...
                   'gui_Singleton', gui_singleton, ...
                   'gui_OpeningFcn', @gui_openingfcn, ...
                   'gui_OutputFcn', @gui_outputfcn, ...
                   'gui_LayoutFcn', [] , ...
                   'gui_Callback', []);
if ((nargin > 1) && (ischar(varargin{1})))
    gui_state.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_state, varargin{:});
else
    gui_mainfcn(gui_state, varargin{:});
end


function gui_openingfcn(hobject, eventdata, handles, varargin)

global self;

handles.output = hobject;
guidata(hobject, handles);

self.handle = handles.mlunit_gui_window;
self.handles = handles;

set(self.handle, 'Name', ['mlUnit ' ver(mlunit, true)]);

set(handles.gui_progress_bar, 'XTick', [], 'XTickLabel', [], 'XTickMode', 'manual', 'XTickLabelMode', 'manual');
set(handles.gui_progress_bar, 'YTick', [], 'YTickLabel', [], 'YTickMode', 'manual', 'YTickLabelMode', 'manual');
set(handles.gui_progress_bar, 'Box', 'on');

menu = uicontextmenu;
set(self.handle, 'UIContextMenu', menu);
self.handles.menu_dock = uimenu(menu, 'Label', 'Dock Window', 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_dock_callback', hobject, [], handles));
self.handles.menu_shorten = uimenu(menu, 'Label', 'Short Directory Names', 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_shorten_callback', hobject, [], handles)); 

if (~isempty(self.dock) && isnumeric(self.dock) && self.dock)
    set(handles.mlunit_gui_window, 'WindowStyle', 'Docked');
    set(self.handles.menu_dock, 'Label', 'Undock Window');
end

if (~ischar(self.initial_test_case))
    try
        test_str = str(self.initial_test_case);
    catch
        test_str = '';
    end
else
    test_str = self.initial_test_case;
end

if ischar(test_str) && ~isempty(test_str)
    set(handles.gui_test_case, 'String', test_str);
end

% Save handle to be recovered later on.
set(self.handle, 'UserData', self);

if self.jumpstart
    gui_run_callback(hobject, eventdata, handles);
end


function varargout = gui_outputfcn(hobject, eventdata, handles) %#ok

varargout{1} = handles.output;


function gui_resize_callback(hobject, eventdata, handles) %#ok

% Since R2008b, MATLAB occasionally calls gui_resize_callback very early,
% presumably to get or update some position values, maybe to obtain a default
% size/position for the window, resulting in a callback invocation
% with empty eventdata and empty handles. Don't really know, how to handle this. Let's
% just not set the positions in that case.
if nargin>=3 && ~isempty(handles)
   position = builtin('get', hobject, 'Position');
   if (position(4) < 20)
       position(4) = 20;
   end
   if (position(3) < 50)
       position(3) = 50;
   end

   flexible_space = position(4) - 14;
   fullwidth = position(3) - 5;
   rightborder = position(3) - 2.5;

   set(handles.gui_text_name, 'Position', ...
       [2.5, position(4) - 2, 20.0, 1]);
   set(handles.gui_test_case, 'Position', ...
       [2.5, position(4) - 4, fullwidth - 10, 1.6]);
   set(handles.gui_run, 'Position', ...
       [rightborder - 10, position(4) - 4, 10.0, 1.6]);
   set(handles.gui_progress_bar, 'Position', ...
       [2.5, position(4) - 7, fullwidth, 1.6]);
   set(handles.gui_text_runs, 'Position', ...
       [2.5, position(4) - 9, fullwidth, 1]);
   set(handles.gui_text_error_list, 'Position', ...
       [2.5, position(4) - 11, 20.0, 1]);
   set(handles.gui_error_list, 'Position', ...
       [2.5, 3 + flexible_space / 2, fullwidth, flexible_space / 2 - 0.4]);
   set(handles.gui_error, 'Position', ...
       [2.5, 3, fullwidth, flexible_space / 2 - 0.4]);
   set(handles.gui_text_time, 'Position', ...
       [2.5, 1.0, 48.0, 1]);
   set(handles.gui_show, 'Position', ...
       [rightborder - 10, 0.7, 10.0, 1.6]);
end


function gui_test_case_callback(hobject, eventdata, handles) %#ok

% accept enter to run immediately, but only if not currently closing
if ~isempty(findobj(handles.mlunit_gui_window)) && ...
        13 == double(builtin('get', handles.mlunit_gui_window, 'CurrentCharacter'))
    gui_run_callback(hobject, eventdata, handles);
end


function gui_test_case_createfcn(hobject, eventdata, handles) %#ok

if ispc && isequal(builtin('get', hobject,'BackgroundColor'), builtin('get', 0,'defaultUicontrolBackgroundColor'))
    set(hobject,'BackgroundColor','white');
end


% Called when the user hits the run button, or pressed enter.
function gui_run_callback(hobject, eventdata, handles) %#ok

set(handles.gui_show, 'Enable', 'off');
set(handles.gui_error, 'String', '');
set(handles.gui_error, 'String', '');
set(handles.gui_text_time, 'String', '');

test_case = builtin('get', handles.gui_test_case, 'String');

if isempty(test_case)
    answer = questdlg('Run all tests in the current directory?', 'mlUnit', 'Yes', 'No', 'Yes');
    if strcmp('Yes', answer)
        test_case = pwd;
        builtin('set', handles.gui_test_case', 'String', test_case);
    end
end

% save general GUI state
self = get(handles.mlunit_gui_window, 'UserData');
if ~isempty(self) && isa(self, 'mlunit_gui')
    mlunit_save_mru_file(test_case, self.dock, self.shorten);
end

% Allow user to save an empty test_case name, but don't run it.
if isempty(test_case)
    return
end

% constructor also resets the display
listener = mlunit_progress_listener_gui(...
    handles.gui_progress_bar, ...
    handles.gui_text_runs, ...
    handles.gui_error_list, ...
    handles.gui_text_time);
suite_runner = add_listener(mlunit_suite_runner, listener);

% disable html links in stack trace, because they won't display in an edit box
prev_linktrace_state = mlunit_param('linked_trace', false);

% Wrap single test specifications if not a valid file/dir.
% Single test specifications contain a dot and their first part needs to be an m file.
test_case_parts = mlunit_strsplit(test_case, '.');
if 0 == exist(test_case, 'file') && ...
        numel(test_case_parts) > 1 && ...
        0 < exist(test_case_parts{1}, 'file')
    test_case = {test_case};
end

try
    run_suite_collection(suite_runner, test_case);
catch
    % display meta error that prevented the suite to execute
    display_meta_error(listener, lasterror);
end

% reset previous state
mlunit_param('linked_trace', prev_linktrace_state);

% execution time gets displayed in the finalize_execution handler

% pretend the user selected one of the errors in order to display something
gui_error_list_callback(handles.gui_error_list, eventdata, handles);


% Called when the user selects an error in the list
function gui_error_list_callback(hobject, eventdata, handles) %#ok

global self;

% cell array of error messages
data = builtin('get', handles.gui_error_list, 'UserData');
% which item the user selected
selected = builtin('get', handles.gui_error_list, 'Value');

% only proceed if we actually recorded errors
if ~isempty(data)
    % set appropriate error message from pool of available messages
    set(handles.gui_error, 'String', shorten_error_text(self, data{selected}));
    
    % (de)activate the show button; function name and line go into its UserData
    [tokens] = regexp(data{selected}, get_line_expression(self), 'tokens', 'once'); %, 'dotexceptnewline');
    if (length(tokens) == 2)
        set(handles.gui_show, 'Enable', 'on');
        set(handles.gui_show, 'UserData', tokens);
    else
        set(handles.gui_show, 'Enable', 'off');
    end
end


function gui_error_list_createfcn(hobject, eventdata, handles) %#ok

if ispc && isequal(builtin('get', hobject,'BackgroundColor'), builtin('get', 0,'defaultUicontrolBackgroundColor'))
    set(hobject,'BackgroundColor','white');
end


function gui_error_createfcn(hobject, eventdata, handles) %#ok

if ispc && isequal(builtin('get', hobject,'BackgroundColor'), builtin('get', 0,'defaultUicontrolBackgroundColor'))
    set(hobject,'BackgroundColor','white');
end


function gui_dock_callback(hObject, eventdata, handles) %#ok

global self;

docked = builtin('get', handles.mlunit_gui_window, 'WindowStyle');
if (strcmp(docked, 'docked'))
    set(handles.mlunit_gui_window, 'WindowStyle', 'Normal');
    set(self.handles.menu_dock, 'Label', 'Dock Window');
    self.dock = 0;
else
    set(handles.mlunit_gui_window, 'WindowStyle', 'Docked');
    set(self.handles.menu_dock, 'Label', 'Undock Window');
    self.dock = 1;
end

% save only docking state
mlunit_save_mru_file([], self.dock);

% cache object
set(handles.mlunit_gui_window, 'UserData', self);


function gui_shorten_callback(hObject, eventdata, handles) %#ok

global self;

if (self.shorten == 0)
    self.shorten = 1;
    set(self.handles.menu_shorten, 'Label', 'Long Directory Names');
else
    self.shorten = 0;
    set(self.handles.menu_shorten, 'Label', 'Short Directory Names');
end
set(handles.mlunit_gui_window, 'UserData', self);

gui_error_list_callback(hObject, eventdata, self.handles);


function gui_show_Callback(hObject, eventdata, handles) %#ok

tokens = builtin('get', hObject, 'UserData');

mfile = tokens{1};
line = tokens{2};

% opentoline struggles with class methods. Help it find them.
mfile = which(mfile);

if isempty(mfile)
    msgbox({[tokens{1} ' cannot be found,'], 'because it is not on the MATLAB path.'}, 'mlUnit', 'warn');
else
    opentoline(mfile, str2double(line));
end


% Relevant gui.fig contents
%
% figure
% FileName            D:\repos\mlunit\mlunit\@mlunit_gui\gui.fig
% KeyPressFcn         gui(mlunit_gui(1), 'gui_test_case_callback',gcbo,[],guidata(gcbo))
% Name                mlUnit
% ResizeFcn           gui(mlunit_gui(1), 'gui_resize_callback',gcbo,[],guidata(gcbo))
% Tag                 mlunit_gui_window
% 
%     uicontrol/text
%     Tag             gui_text_name
%     String          Test Object:
% 
%     uicontrol/edit
%     Callback        gui(mlunit_gui(1), 'gui_test_case_callback',gcbo,[],guidata(gcbo))
%     CreateFcn       gui(mlunit_gui(1), 'gui_test_case_createfcn',gcbo,[],guidata(gcbo))
%     Tag             gui_test_case
% 
%     uicontrol/pushbutton
%     Callback        gui(mlunit_gui(1), 'gui_run_callback',gcbo,[],guidata(gcbo))
%     String          Run
%     Tag             gui_run
% 
%     axes
%     Tag             gui_progress_bar
% 
%     uicontrol/text
%     String          Tests: 0 / Errors: 0 / Failures: 0 / Skipped: 0
%     Tag             gui_text_runs
% 
%     uicontrol/text
%     String          Errors / Failures:
%     Tag             gui_text_error_list
% 
%     uicontrol/listbox
%     Callback        gui(mlunit_gui(1), 'gui_error_list_callback',gcbo,[],guidata(gcbo))
%     CreateFcn       gui(mlunit_gui(1), 'gui_error_list_createfcn',gcbo,[],guidata(gcbo))
%     Tag             gui_error_list
% 
%     uicontrol/edit
%     CreateFcn       gui(mlunit_gui(1), 'gui_error_createfcn',gcbo,[],guidata(gcbo))
%     Tag             gui_error
% 
%     uicontrol/text
%     Tag             gui_text_time
% 
%     uicontrol/pushbutton
%     Callback        gui(mlunit_gui(1), 'gui_show_Callback',gcbo,[],guidata(gcbo))
%     Tag             gui_show
