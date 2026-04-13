%Update display with next test case result.
%  SELF = next_result(SELF, RESULT) notifies the listener of a completed test
%  run, providing it with the result. SELF is a mlunit_progress_listener_gui instance.
%  RESULT is the test result as returned by run_test().
%
%  This method is provided by the user, but should not be called by her.
%
%  See also init_results, run_test

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = next_result(self, result)

self.num_results = self.num_results + 1;
self.num_all_results = self.num_all_results + 1;

has_errors = ~isempty(result.errors);
has_failed = ~isempty(result.failure);
has_skipped = ~isempty(result.skipped);

if has_failed
    self.num_failures = self.num_failures + 1;
    failmsg = '';
    stack = [];
    if ~isempty(result.failure)
        [failmsg, stack] = get_message_with_stack(result.failure);
    end
    self = add_to_errorlist(self, 'FAIL', result.name, failmsg, stack);
end

if has_skipped
    self.num_skipped = self.num_skipped + 1;
    skipmsg = '';
    stack = [];
    if ~isempty(result.skipped)
        [skipmsg, stack] = get_message_with_stack(result.skipped);
    end
    self = add_to_errorlist(self, 'SKIPPED', result.name, skipmsg, stack);
end

if has_errors
    self.num_errors = self.num_errors + 1;
    
    % consolidate multiple errors into single string
    [msg_list, stack_list] = cellfun(@get_message_with_stack, result.errors, 'UniformOutput', false);
    errmessages = mlunit_strjoin(msg_list, sprintf('\n'));
    
    % use the first non-empty stack found for populating the View button
    stack = [];
    for i = 1:numel(stack_list)
        if ~isempty(stack_list{i})
            stack = stack_list{i};
            break;
        end
    end
    
    self = add_to_errorlist(self, 'ERROR', result.name, errmessages, stack);
end

if mlunit_param('verbose') && ~has_errors && ~has_failed
    self = add_to_errorlist(self, 'ok', result.name, 'success');
end

update_display(self);
