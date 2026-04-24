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

% Maintenance:
% - The eventdata variable has never been used and can be removed.
%   It needs to be removed from the function argument lists and the .fig calls.
% - gui(..) isn't really an instance method, but a class method.
%   It doesn't use any data outside of its own global variable.
% - The global "self" variable is mainly used for remembering the figure's handles.
% - The figure's UserData property is used for communicating the value of the global
%   "self" variable from the gui_openingfcn callback.
% - It's all a bit of a mess.

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
self.handles.menu_shorten = uimenu(menu, 'Label', shorten_menu_text(self.shorten), 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_shorten_callback', hobject, [], handles));
self.handles.menu_about = uimenu(menu, 'Label', 'About mlUnit', 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_about_callback', hobject, [], handles)); 

if (~isempty(self.dock) && isnumeric(self.dock) && self.dock)
    set(handles.mlunit_gui_window, 'WindowStyle', 'Docked');
    set(self.handles.menu_dock, 'Label', 'Undock Window');
end

copymenu = uicontextmenu;
set(self.handles.gui_error, 'UIContextMenu', copymenu);
self.handles.menu_copyerror = uimenu(copymenu, 'Label', 'Copy', 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_copy_callback', hobject, [], handles));

if (~ischar(self.initial_test_case))
    try
        test_str = class(self.initial_test_case);
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


function varargout = gui_outputfcn(hobject, eventdata, handles)

global self;

varargout{1} = handles.output;

if self.jumpstart
    gui_run_callback(hobject, eventdata, handles);
end


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
        isequal(13, double(builtin('get', handles.mlunit_gui_window, 'CurrentCharacter')))
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
set(handles.gui_text_time, 'String', '');
set(handles.gui_run, 'Enable', 'off');
% set keyboard focus to error list, so users can navigate results
uicontrol(handles.gui_error_list);
cleanup = onCleanup(@() set(handles.gui_run, 'Enable', 'on'));

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
    mlunit_save_mru_file(test_case, self.dock);
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

% set focus
value = get(handles.gui_error_list, 'Value');
set(handles.gui_error_list, 'Value', value);


% Called when the user selects an error in the list
function gui_error_list_callback(hobject, eventdata, handles, preselection) %#ok

global self;

if nargin < 4, preselection = false; end

% cell array of error messages
data = builtin('get', handles.gui_error_list, 'UserData');

% only proceed if we actually recorded errors
if ~isempty(data)
    
    if preselection
        % If just one entry, select that.
        % Otherwise, select the first test, which will be the second item.
        index = min(2, numel(data));
        % Match selection
        set(handles.gui_error_list, 'Value', index);
    else
        % which item the user selected
        index = builtin('get', handles.gui_error_list, 'Value');
    end
    
    errobj = data{index};

    [errortext, stackobj] = process_errors(errobj, self.shorten);
    
    % set appropriate error message from pool of available messages
    set(handles.gui_error, 'String', errortext);
    
    % (de)activate the show button; function name and line go into its UserData
    if ~isempty(stackobj)
        set(handles.gui_show, 'Enable', 'on');
        set(handles.gui_show, 'UserData', stackobj);
    else
        set(handles.gui_show, 'Enable', 'off');
    end
end


function [errortext, stackobj] = process_errors(errorinfo_list, shorten)

% consolidate multiple errors into single string
%#ok<*CHARTEN> newline isn't on all supported MATLAB releases
msg_list = cell(size(errorinfo_list));
stack_list = cell(size(errorinfo_list));
for i = 1:numel(errorinfo_list)
    ei = errorinfo_list{i};
    if ischar(ei)
        msg_list{i} = ei;
    else
        [msg_list{i}, stack_list{i}] = get_message_with_stack(ei, char(10), false, shorten);
    end
end
errortext = mlunit_strjoin(msg_list, char(10));

% use the first non-empty stack found for populating the View button
stack = [];
for i = 1:numel(stack_list)
    if ~isempty(stack_list{i})
        stack = stack_list{i};
        break;
    end
end

stackobj = struct('file', {}, 'line', {});
if ~isempty(stack)
    stackobj = stack(1);
end


function gui_error_list_createfcn(hobject, eventdata, handles) %#ok

if ispc && isequal(builtin('get', hobject,'BackgroundColor'), builtin('get', 0,'defaultUicontrolBackgroundColor'))
    set(hobject,'BackgroundColor','white');
end

% register keypess callback
set(hobject, 'KeyPressFcn', @gui_error_list_keypress);


function gui_error_list_keypress(hobject, keyevent)

if isequal(13, keyevent.Character)
    
    current_guidata = guidata(hobject);
    
    isviewable = strcmpi('on', get(current_guidata.gui_show, 'Enable'));
    
    if isviewable
        % trigger Show event
        gui_show_Callback(current_guidata.gui_show, [], current_guidata);
    end
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

self.shorten = ~self.shorten;
set(self.handles.menu_shorten, 'Label', shorten_menu_text(self.shorten));
set(handles.mlunit_gui_window, 'UserData', self);

gui_error_list_callback(hObject, eventdata, self.handles);

% save only shorten state
mlunit_save_mru_file([], [], self.shorten);


function text = shorten_menu_text(shorten)

% The text is flipped, because it describes what the user can switch to.
if shorten
    text = 'Long Stack Paths';
else
    text = 'Short Stack Names';
end


function gui_about_callback(hObject, eventdata, handles) %#ok

version = ver('mlunit');
text = {...
    [version.Name ' ' version.Version], ...
    [version.Date], ...
    ['Supports MATLAB ' version.Release], ...
    '', ...
    'See CHANGES.txt at', ...
    'https://github.com/AxelBerres/mlunit', ...
    };
msgbox(text, 'About mlUnit', 'help');


function gui_copy_callback(hObject, eventdata, handles) %#ok

char_matrix = get(handles.gui_error, 'String');
text = mlunit_strjoin(cellstr(char_matrix), char(10));
clipboard('copy', text);


function gui_show_Callback(hObject, eventdata, handles) %#ok

errobj = builtin('get', hObject, 'UserData');

mfile = errobj.file;
line = errobj.line;

% opentoline struggles with class methods. Help it find them.
mfile = which(mfile);

if ~isempty(mfile)
    opentoline(mfile, line);
else
    % should not occur any more
    msgbox({[errobj.file ' cannot be found,'], 'because it is not on the MATLAB path.'}, 'mlUnit', 'warn');
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
