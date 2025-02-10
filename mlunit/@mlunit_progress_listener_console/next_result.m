%Update display with next test case result.
%
%  SELF = next_result(SELF, RESULT) notifies the listener of a completed test
%  run, providing it with the result. SELF is a mlunit_progress_listener_gui instance.
%  RESULT is the test result as returned by run_test().
%
%  This method is provided by the user, but should not be called by her.
%
%  See also init_results, run_test

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

%#ok<*SPRINTFN>

function self = next_result(self, result)

mlunit_narginchk(2, 2, nargin);
if ~isstruct(result), error('result argument need be struct'); end

% consolidate multiple errors into single string
msg_and_stack_list = cellfun(@get_message_with_stack, result.errors, 'UniformOutput', false);
errmessages = mlunit_strjoin(msg_and_stack_list, sprintf('\n'));

has_errors = ~isempty(errmessages);
has_failed = ~isempty(result.failure);
has_skipped = ~isempty(result.skipped);
num_variations = 0;
if isfield(result, 'variations') && numel(result.variations) > 0
    num_variations = sum([result.variations.variations]);
end
has_variations = num_variations > 0;

report = '';
variation_info = '';
if has_variations
    variation_info = loc_variation_info(num_variations, result.variations);
end

if has_skipped
    msg = sprintf('\n  %s SKIPPED', result.name);
    if ~strcmp('(no message available)', result.skipped)
        msg = [msg sprintf(':\n%s', indent(result.skipped))];
    end
    report = [report msg];
    
elseif has_failed
    report = [report sprintf('\n  %s FAIL:\n%s%s', result.name, variation_info, indent(result.failure))];
end

if has_errors
    if has_skipped || has_failed
        % inject additional newline for joining fail/skip and error block of the same
        % test case
        report = [report sprintf('\n')];
    end
    report = [report sprintf('\n  %s ERROR:\n%s%s', result.name, variation_info, indent(errmessages))];
end

if mlunit_param('verbose') && ~has_errors && ~has_failed && ~has_skipped
    if has_variations
        num_skips = sum([result.variations.skips]);
        skip_info = '';
        if num_skips > 0
            skip_info = sprintf(', %d SKIPPED', num_skips);
        end
            
        variation_info = sprintf(' (%d variations%s)', sum([result.variations.variations]), skip_info);
    end
    if self.has_preceding_detailed_output
        report = [report sprintf('\n')];
    end
    report = [report sprintf('  %s%s', result.name, variation_info)];
    self.has_preceding_detailed_output = false;
else
    self.has_preceding_detailed_output = true;
end

disp(report);


% Indent text by 4 spaces at beginning and after each newline
function indented = indent(text)

   space = '    ';
   indented = [space regexprep(text, '\n', ['\n' space])];


function variation_info = loc_variation_info(num_variations, variation_data)

    skip_info = '';
    num_skips = sum([variation_data.skips]);
    if num_skips > 0
        skip_info = sprintf(', %d SKIPPED', num_skips);
    end

    fail_info = '';
    num_failures = sum([variation_data.failures]);
    if num_failures > 0
        fail_info = sprintf(', %d FAILED', num_failures);
    end

    error_info = '';
    num_errors = sum([variation_data.errors]);
    if num_errors > 0
        error_info = sprintf(', %d had ERRORS', num_errors);
    end

    variation_info = sprintf('    Ran %d variations%s%s%s\n', num_variations, skip_info, fail_info, error_info);
