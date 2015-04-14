%Add an entry to the GUI's error list.
%  add_to_errorlist(SELF, PREFIX, TESTNAME, ERRMSG) adds an error to the GUI's
%  error list. SELF is an mlunit_progress_listener_gui instance. PREFIX is supposed to be
%  either 'ERROR' or 'FAIL', depending on the error type. TESTNAME is a string,
%  used for display in the error list. ERRMSG is the full error message (with
%  stack) that will be displayed in the error detail box.
%
%  This is an mlunit_progress_listener_gui internal method and should not be called from
%  the outside.
%
%  See next_result, display_meta_error

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function add_to_errorlist(self, prefix, testname, errmsg)

error(nargchk(4, 4, nargin, 'struct'));

% get existing error list
list = builtin('get', self.error_listbox, 'String');
data = builtin('get', self.error_listbox, 'UserData');
if isempty(list)
    list = cell(0);
    data = cell(0);
end

% add current error
list{end+1} = sprintf('%s: %s', prefix, testname);
data{end+1} = errmsg;

% write back
set(self.error_listbox, 'String', list);
set(self.error_listbox, 'UserData', data);
% auto-select first item
set(self.error_listbox, 'Value', 1);
