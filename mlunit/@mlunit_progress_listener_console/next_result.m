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
%  
%  $Id$

function self = next_result(self, result)

mlunit_narginchk(2, 2, nargin);
if ~isstruct(result), error('result argument need be struct'); end

% consolidate multiple errors into single string
msg_and_stack_list = cellfun(@get_message_with_stack, result.errors, 'UniformOutput', false);
errmessages = mlunit_strjoin(msg_and_stack_list, sprintf('\n'));

has_errors = ~isempty(errmessages);
has_failed = ~isempty(result.failure);
has_skipped = ~isempty(result.skipped);

report = '';

if has_skipped
    msg = sprintf('\n  %s SKIPPED', result.name);
    if ~strcmp('(no message available)', result.skipped)
        msg = [msg sprintf(':\n%s', indent(result.skipped))];
    end
    report = [report msg];
    
elseif has_failed
    report = [report sprintf('\n  %s FAIL:\n%s', result.name, indent(result.failure))];
end

if has_errors
    if has_skipped || has_failed
        % inject additional newline for joining fail/skip and error block of the same
        % test case
        report = [report sprintf('\n')];
    end
    report = [report sprintf('\n  %s ERROR:\n%s', result.name, indent(errmessages))];
end

if mlunit_param('verbose') && ~has_errors && ~has_failed && ~has_skipped
    report = [report sprintf('  %s', result.name)];
end

disp(report);


% Indent text by 4 spaces at beginning and after each newline
function indented = indent(text)

   space = '    ';
   indented = [space regexprep(text, '\n', ['\n' space])];
