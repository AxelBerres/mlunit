%Add an entry to the GUI's error list.
%  add_to_errorlist(SELF, PREFIX, TESTNAME, ERROBJS) adds an error to the GUI's
%  error list. SELF is an mlunit_progress_listener_gui instance. PREFIX is supposed to be
%  either 'ERROR' or 'FAIL', depending on the error type. TESTNAME is a string,
%  used for display in the error list. ERROBJS is a cell array of error objects.
%
%  This is an mlunit_progress_listener_gui internal method and should not be called from
%  the outside.
%
%  See next_result, display_meta_error

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = add_to_errorlist(self, prefix, testname, errobjs)

mlunit_narginchk(4, 4, nargin);

% get existing error list
list = builtin('get', self.error_listbox, 'String');
data = builtin('get', self.error_listbox, 'UserData');
if isempty(list)
    list = {};
    data = {};
end

% add testsuite once
if ~isempty(self.current_suite)
    list{end+1} = self.current_suite;
    data{end+1} = '';
    self.current_suite = '';
end

% normalize errobjs
if ischar(errobjs)
    errobjs = {mlunit_errorinfo(struct('message', errobjs))};
elseif isobject(errobjs)
    errobjs = {errobjs};
elseif ~iscell(errobjs)
    errobjs = {mlunit_errorinfo(struct('message', 'Argument errobjs is not of a recognized type.'), 'Internal mlUnit error.')};
end

% add current error
list{end+1} = sprintf('      %s: %s', prefix, testname);
data{end+1} = errobjs;

% write back
set(self.error_listbox, 'String', list);
set(self.error_listbox, 'UserData', data);

% auto-select first item
if numel(data) <= 2
    % For normal execution, the first test is the second item,
    % but for abnormal executions, we only have one item containing a meta error.
    set(self.error_listbox, 'Value', numel(data));
    % Make the selection appear to have focus and show the error text.
    gui(mlunit_gui(1), 'gui_error_list_callback', self.error_listbox, [], guidata(self.error_listbox));
end
