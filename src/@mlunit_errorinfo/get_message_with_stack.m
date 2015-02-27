%Get an error's message and stack as single string.
%  get_message_with_stack works on the internally buffered error information
%  that you provided in mlunit_errorinfo's constructor. The actual message and
%  stack get processed according to it being an mlUnit failure or a plain error.
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

% reduce the stack of failures for better overview
if is_failure(self)
    stack = filter_failure_stack(self, stack);
end

% put message and stack together
message = [message, loc_print_stack(stack)];


%Build a single stactracke string out of a stack structure.
%  stack is the stack structure as returned by lasterror().stack or dbstack().
function stackstring = loc_print_stack(stack)

stackstring = '';
for i = 1:size(stack, 1)
    stackstring = sprintf('%s\nIn %s at line %d', ...
        stackstring, ...
        stack(i).file, stack(i).line);
end
