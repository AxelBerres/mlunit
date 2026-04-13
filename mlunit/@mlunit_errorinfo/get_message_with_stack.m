%Get an error's message and stack as single string.
%  get_message_with_stack works on the internally buffered error information
%  that you provided in mlunit_errorinfo's constructor. The actual message and
%  stack get processed according to it being an mlUnit failure or a plain error.
%
%  message = get_message_with_stack(self) returns a char array containing the
%  message and stack.
%
%  [message, stack] = get_message_with_stack(self) additionally returns the stack.
%
%  The stack display format can be changed by the mlUnit parameter 'linked_trace'.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function [message, stack] = get_message_with_stack(self)

% obtain message and stack
[message, stack] = get_message(self);

% put message and stack together
message = [message, mlunit_print_stack(stack)];
