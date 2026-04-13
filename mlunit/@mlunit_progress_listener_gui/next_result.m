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
    if ~isempty(result.failure)
        failmsg = get_message_with_stack(result.failure);
    end
    self = add_to_errorlist(self, 'FAIL', result.name, failmsg);
end

if has_skipped
    self.num_skipped = self.num_skipped + 1;
    skipmsg = '';
    if ~isempty(result.skipped)
        skipmsg = get_message_with_stack(result.skipped);
    end
    self = add_to_errorlist(self, 'SKIPPED', result.name, skipmsg);
end

if has_errors
    self.num_errors = self.num_errors + 1;
    
    % consolidate multiple errors into single string
    msg_and_stack_list = cellfun(@get_message_with_stack, result.errors, 'UniformOutput', false);
    errmessages = mlunit_strjoin(msg_and_stack_list, sprintf('\n'));
    
    self = add_to_errorlist(self, 'ERROR', result.name, errmessages);
end

if mlunit_param('verbose') && ~has_errors && ~has_failed
    self = add_to_errorlist(self, 'ok', result.name, 'success');
end

update_display(self);
