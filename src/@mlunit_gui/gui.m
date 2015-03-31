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
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id$

global self;

if ((object.callback ~= 1) && (isempty(self) || (isempty(get_object(self)))))
    self = object;
elseif ((object.callback == 1) && (isempty(self)))
    handles = guidata(gcbo);
    try
        self = builtin('get', handles.gui_window, 'UserData');
    catch
    end;
end;

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

function gui_openingfcn(hobject, eventdata, handles, varargin) %#ok

global self;

handles.output = hobject;
guidata(hobject, handles);

self.handle = handles.gui_window;
self.handles = handles;

set(handles.gui_progress_bar, 'XTick', [], 'XTickLabel', []);
set(handles.gui_progress_bar, 'YTick', [], 'YTickLabel', []);

menu = uicontextmenu;
set(self.handle, 'UIContextMenu', menu);
self.handles.menu_dock = uimenu(menu, 'Label', 'Dock Window', 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_dock_callback', hobject, [], handles));
self.handles.menu_shorten = uimenu(menu, 'Label', 'Short Directory Names', 'Callback', ...
    @(hobject, eventdata)gui(mlunit_gui(1), 'gui_shorten_callback', hobject, [], handles)); 

if (~isempty(self.dock) && isnumeric(self.dock) && self.dock)
    set(handles.gui_window, 'WindowStyle', 'Docked');
    set(self.handles.menu_dock, 'Label', 'Undock Window');
end;

if (~ischar(self.test_case))
    try
        test_str = str(self.test_case);
    catch
        test_str = '';
    end;
else
    test_str = self.test_case;
end;
if (ischar(test_str) && ~isempty(test_str))
    set(handles.gui_test_case, 'String', test_str);
    gui_run_callback(hobject, eventdata, handles);
    self.test_case = '';
end

set(self.handle, 'UserData', self);

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
   end;
   if (position(3) < 50)
       position(3) = 50;
   end;

   space = position(4) - 30.0;

   set(handles.gui_text_name, 'Position', [2.5 position(4) - 2.5 20.0 1]);
   set(handles.gui_test_case, 'Position', [2.5 position(4) - 4.5 position(3) - 15 1.6]);
   set(handles.gui_run, 'Position', [position(3) - 12.5 position(4) - 4.5 10.0 1.6]);
   set(handles.gui_show, 'Position', [position(3) - 12.5 position(4) - 28.8 - space 10.0 1.6]);
   set(handles.gui_progress_bar, 'Position', [2.5 position(4) - 7.5 position(3) - 5.0 1.6]);
   set(handles.gui_text_runs, 'Position', [2.5 position(4) - 9.5 40.0 1]);
   set(handles.gui_text_error_list, 'Position', [2.5 position(4) - 12 20.0 1]);
   set(handles.gui_error_list, 'Position', [2.5 position(4) - 19.5 - space / 2 position(3) - 5.0 7 + space / 2]);
   set(handles.gui_error, 'Position', [2.5 position(4) - 27 - space position(3) - 5.0 7 + space / 2]);
   set(handles.gui_text_time, 'Position', [2.5 1.0 48.0 1]);
end

function gui_test_case_callback(hobject, eventdata, handles) %#ok

if (double(builtin('get', handles.gui_window, 'CurrentCharacter')) == 13)
    gui_run_callback(hobject, eventdata, handles);
end;

function gui_test_case_createfcn(hobject, eventdata, handles) %#ok

if ispc && isequal(builtin('get', hobject,'BackgroundColor'), builtin('get', 0,'defaultUicontrolBackgroundColor'))
    set(hobject,'BackgroundColor','white');
end


% Called when the user hits the run button
function gui_run_callback(hobject, eventdata, handles) %#ok

set(handles.gui_show, 'Enable', 'off');
set(handles.gui_error, 'String', '');
set(handles.gui_error, 'String', '');
set(handles.gui_text_time, 'String', '');
test_case = builtin('get', handles.gui_test_case, 'String');

suite_runner = mlunit_suite_runner;
% constructor also resets the display
listener = mlunit_gui_listener(...
    handles.gui_progress_bar, ...
    handles.gui_text_runs, ...
    handles.gui_error_list);
suite_runner = add_listener(suite_runner, listener);

% disable html links in stack trace, because they won't display in an edit box
prev_linktrace_state = mlunit_param('linked_trace', false);

time = 0;
try
    [results, time] = run_suite(suite_runner, test_case);
catch
    % display meta error that prevented the suite to execute
    display_meta_error(listener, lasterror);
end

% reset previous state
mlunit_param('linked_trace', prev_linktrace_state);

% display execution time
set(handles.gui_text_time, 'String', sprintf('Finished: %.3fs.\n', time));

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
    end;
end;

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

docked = builtin('get', handles.gui_window, 'WindowStyle');
if (strcmp(docked, 'docked'))
    set(handles.gui_window, 'WindowStyle', 'Normal');
    set(self.handles.menu_dock, 'Label', 'Dock Window');
    self.dock = 0;
else
    set(handles.gui_window, 'WindowStyle', 'Docked');
    set(self.handles.menu_dock, 'Label', 'Undock Window');
    self.dock = 1;
end;
set(handles.gui_window, 'UserData', self);

function gui_shorten_callback(hObject, eventdata, handles) %#ok

global self;

if (self.shorten == 0)
    self.shorten = 1;
    set(self.handles.menu_shorten, 'Label', 'Long Directory Names');
else
    self.shorten = 0;
    set(self.handles.menu_shorten, 'Label', 'Short Directory Names');
end;
set(handles.gui_window, 'UserData', self);

gui_error_list_callback(hObject, eventdata, self.handles);

function gui_show_Callback(hObject, eventdata, handles) %#ok

tokens = builtin('get', hObject, 'UserData');
if ((length(tokens) == 3) && (etime(clock, tokens{3}) < 1))
    data = builtin('get', handles.gui_error_list, 'UserData');
    selected = builtin('get', handles.gui_error_list, 'Value');
    [tokens] = regexp(data{selected}, get_line_expression(self), 'tokens', 'once'); %, 'dotexceptnewline');
    if (length(tokens) > 1)
        second = tokens{2};
        com.mathworks.mlservices.MLEditorServices.openDocumentToLine(second{1},str2num(second{2})); %#ok
    end;
else
    com.mathworks.mlservices.MLEditorServices.openDocumentToLine(tokens{1},str2num(tokens{2})); %#ok
    tokens{3} = clock;
    set(hObject, 'UserData', tokens);
end;
