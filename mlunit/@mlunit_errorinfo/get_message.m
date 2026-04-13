%Get an error's message and its stack as separate entries.
%  get_message works on the internally buffered error information
%  that you provided in mlunit_errorinfo's constructor. The actual message and
%  stack get processed according to it being an mlUnit failure or a plain error.
%
%  [message, stack] = get_message(self) returns a char array containing the
%  message and a struct array containing the stack.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function [message, stack] = get_message(self)

% obtain message and stack
[message, stack] = filter_lasterror_wraps(self);

% reduce the stack of failures or skips for better overview
stack = filter_failure_stack(self, stack);
