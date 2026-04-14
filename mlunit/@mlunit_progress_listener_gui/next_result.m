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
    self = add_all(self, 'FAIL', result.name, {result.failure});
end

if has_skipped
    self.num_skipped = self.num_skipped + 1;
    self = add_all(self, 'SKIPPED', result.name, {result.skipped});
end

if has_errors
    self.num_errors = self.num_errors + 1;
    self = add_all(self, 'ERROR', result.name, result.errors);
end

if mlunit_param('verbose') && ~has_errors && ~has_failed && ~has_skipped
    self = add_to_errorlist(self, 'ok', result.name, 'success');
end

update_display(self);


function self = add_all(self, result, name, errorinfo_list)

    % consolidate multiple errors into single string
    %#ok<*CHARTEN> newline isn't on all supported MATLAB releases
    [msg_list, stack_list] = cellfun( ...
        @(ei) get_message_with_stack(ei, char(10)), ...
        errorinfo_list, ...
        'UniformOutput', false);
    message = mlunit_strjoin(msg_list, char(10));
    
    % use the first non-empty stack found for populating the View button
    stack = [];
    for i = 1:numel(stack_list)
        if ~isempty(stack_list{i})
            stack = stack_list{i};
            break;
        end
    end
    
    self = add_to_errorlist(self, result, name, message, stack);
