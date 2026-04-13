%Add an entry to the GUI's error list.
%  add_to_errorlist(SELF, PREFIX, TESTNAME, ERRMSG, STACK) adds an error to the GUI's
%  error list. SELF is an mlunit_progress_listener_gui instance. PREFIX is supposed to be
%  either 'ERROR' or 'FAIL', depending on the error type. TESTNAME is a string,
%  used for display in the error list. ERRMSG is the full error message (with
%  stack) that will be displayed in the error detail box. STACK is a struct array of stack
%  items from which the first will be selected as jumping point for the View button.
%
%  This is an mlunit_progress_listener_gui internal method and should not be called from
%  the outside.
%
%  See next_result, display_meta_error

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = add_to_errorlist(self, prefix, testname, errmsg, stack)

mlunit_narginchk(4, 5, nargin);

if nargin < 5, stack = []; end

% get existing error list
list = builtin('get', self.error_listbox, 'String');
data = builtin('get', self.error_listbox, 'UserData');
if isempty(list)
    list = cell(0);
    data = cell(0);
end

% add testsuite once
if ~isempty(self.current_suite)
    list{end+1} = self.current_suite;
    data{end+1} = '';
    self.current_suite = '';
end

% data item consists of the display text, and the jumping point for the View button
errobj = struct();
errobj.text = errmsg;
errobj.file = '';
errobj.line = [];
if ~isempty(stack)
    errobj.file = stack(1).file;
    errobj.line = stack(1).line;
end

% add current error
list{end+1} = sprintf('      %s: %s', prefix, testname);
data{end+1} = errobj;

% write back
set(self.error_listbox, 'String', list);
set(self.error_listbox, 'UserData', data);

% auto-select first item
if numel(data) <= 2
    % For normal execution, the first test is the second item,
    % but for abnormal executions, we only have one item containing a meta error.
    set(self.error_listbox, 'Value', numel(data));
    % Make the selection appear to have focus and show the error text.
    eval(get(self.error_listbox, 'Callback'));
end
