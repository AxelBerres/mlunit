%Get an error's message and stack as single string.
%  filter_lasterror_wraps works on the internally buffered error information
%  that you provided in mlunit_errorinfo's constructor.
%
%  message = get_message_with_stack(self) returns a char array containing the
%  message and stack.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function message = get_message_with_stack(self)

% obtain message and stack
[message, stack] = filter_lasterror_wraps(self);

% put message and stack together
message = [message, mlunit_print_stack(stack)];
