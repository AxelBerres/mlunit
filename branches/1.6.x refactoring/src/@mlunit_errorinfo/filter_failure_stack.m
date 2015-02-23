%Restrict a failure's stack to items relevant to the user.
%  stack = filter_failure_stack(self, stack) takes a stack (that may already
%  have been changed from the internal mlunit_errorinfo stack) and omits
%  those items that are mlUnit internal calls. The remaining items are the ones
%  relevant to the user.
%
%  See is_failure, get_message_with_stack

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function stack = filter_failure_stack(self, stack)

error(nargchk(2, 2, nargin, 'struct'));

% Return if empty, some of our calculations don't work on empty structs
if isempty(stack)
    return
end

% Annotate stack items with extracted file name.
% The resulting stack.filename are
% the names of the files each function call occurred, stack.name are the
% names of each (sub)function, which we do not know or want to filter by.
for f=1:numel(stack)
    [fpath fname] = fileparts(stack(f).file);
    stack(f).filename = fname;
end

% Pop all internal delegating assert calls from the stack. Assumes that we
% are getting called through a chain of files named assert, assert_* or
% fail. Stop at the first item not one of the list names.
filtered_files = {'assert_true', ...
                  'assert_false', ...
                  'assert_equals', ...
                  'assert_not_equals', ...
                  'assert_empty', ...
                  'assert_not_empty', ...
                  'assert_error', ...
                  'assert_warning', ...
                  'abstract_assert_equals', ...
                  'fail', ...
                  };
while ~isempty(stack) && any(strcmpi(stack(1).filename, filtered_files))
    stack(1)=[];
end

% Pop all internal managing calls from the stack. These are at the back, i.e.
% higher in the call chain. For failures, these are of no interest and only
% muddle the output. Delete everything after the last/highest-up occurrence of
% the test file. Use the test file in order to account for test functions, but
% also tear_down and set_up.
first_handler_idx = find(strcmp({stack.filename}, 'run_test'), 1, 'first');
stack(first_handler_idx:end) = [];

% remove temporary filename field
stack = rmfield(stack, 'filename');
