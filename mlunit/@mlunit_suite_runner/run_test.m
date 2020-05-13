%Execute a single test case.
%  RESULT = run_test(SELF, TEST) executes test case TEST.
%  SELF is an mlunit_suite_runner instance. TEST is a test_case instance.
%  TEST must exist.
%  
%  RESULT is a scalar struct with fields:
%    - name    : string, the test case name, mandatory
%    - errors  : cell array of mlunit_errorinfo objects,
%                all errors that occurred during execution
%                empty cell array, if no errors occurred
%    - failure : string, the failure message, empty, if no failure occurred
%    - skipped : string, the skip message, empty, if not skipped
%    - time    : double, the execution time in seconds
%    - console : string, the console output of the test and its fixtures
%
%  [RESULT, SELF, TEST] = run_test(SELF, TEST) does the same, but also provides
%  SELF back, the mlunit_suite_runner instance. Its states may have changed 
%  by means of changed listeners. TEST is a copy of the input argument, used by
%  mlUnit's internal unit tests.
%
%  After test execution, the mlUnit environment will be reset to the state it
%  has before test execution.
%
%  See also mlunit_environment.

%#ok<*CHARTEN>

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function [result, self, test] = run_test(self, test)

    % if disabled statically, don't really execute any fixture or test
    if get_disabled(test)
        result = construct_disabled_result(test);
        self = notify_listeners(self, 'next_result', result);
        return
    end

    start_time = clock;

    % buffer environment for reset after each test case
    previous_environment = mlunit_environment();
    
    % execute set_up fixture
    test_failure = '';
    test_skipped = '';
    errors = {};
    outputSetup = '';
    try
        if mlunit_param('catch_output')
            [outputSetup, test] = evalc('set_up(test);');
        else
            test = set_up(test);
        end
    catch
        err = lasterror;
        errorinfo = mlunit_errorinfo(err);
        if is_failure(errorinfo)
            errorinfo = set_additional_cause(errorinfo, 'In set_up fixture:');
            test_failure = get_message_with_stack(errorinfo);
        elseif is_skipped(errorinfo)
            errorinfo = set_additional_cause(errorinfo, 'In set_up fixture:');
            test_skipped = get_message_with_stack(errorinfo);
        else
            legacy_stack_handling(err);
            errorinfo = set_additional_cause(errorinfo, 'Error in set_up fixture:');
            errors{end+1} = errorinfo;
        end
    end

    % execute test, only if set_up prevailed
    outputTest = '';
    if isempty(errors) && isempty(test_failure) && isempty(test_skipped)
        method = get_name(test);
        try
            if mlunit_param('catch_output')
                [outputTest, test] = evalc([method, '(test);']);
            else
                test = eval([method, '(test);']);
            end
        catch
            err = lasterror;
            errorinfo = mlunit_errorinfo(err);
            if is_failure(errorinfo)
                test_failure = get_message_with_stack(errorinfo);
            elseif is_skipped(errorinfo)
                test_skipped = get_message_with_stack(errorinfo);
            else
                legacy_stack_handling(err);
                errors{end+1} = errorinfo;
            end
        end
    end

    % execute tear_down fixture in any case, even if set_up or test failed
    outputTeardown = '';
    try
        if mlunit_param('catch_output')
            [outputTeardown, test] = evalc('tear_down(test);');
        else
            test = tear_down(test);
        end
    catch
        errorinfo = mlunit_errorinfo(lasterror);
        if is_failure(errorinfo)
            errorinfo = set_additional_cause(errorinfo, 'Assertion failed in tear_down fixture, which is not allowed and treated as error:');
        elseif is_skipped(errorinfo)
            errorinfo = set_additional_cause(errorinfo, 'Skipping is not possible in tear_down fixture:');
        else
            errorinfo = set_additional_cause(errorinfo, 'Error in tear_down fixture:');
        end
        
        % Skips and failures during tear_down get mapped to errors, because tear_down is
        % always executed as a fail-safe. If we allowed skips and failures, this means
        % that a test could have several failures and several skips.
        errors{end+1} = errorinfo;
    end

    % restore previous environment after test and fixtures finished
    [dummy, envErrors] = mlunit_environment(previous_environment);
    if ~isempty(envErrors)
        errors{end+1} = mlunit_errorinfo(envErrors, 'Error(s) during environment reset after tear_down fixture. Maybe due to open file handles? Models left in compile state?');
    end

    % build result structure
    result = struct();
    result.name = get_function_name(test);
    result.errors = errors;
    result.failure = test_failure;
    result.skipped = test_skipped;
    result.time = etime(clock, start_time);
    
    if mlunit_param('mark_testphase')
        result.console = mlunit_strjoin({...
            prepend(outputSetup, '[setup] ') ...
            prepend(outputTest, '[test]  ') ...
            prepend(outputTeardown, '[tdown] ') ...
            }, '');
    else
        result.console = mlunit_strjoin({outputSetup, outputTest, outputTeardown}, '');
    end
    
    self = notify_listeners(self, 'next_result', result);


function result = construct_disabled_result(test)
    % build result structure
    result = struct();
    result.name = get_function_name(test);
    result.errors = {};
    result.failure = '';
    [dummy, reason] = get_disabled(test);
    if isempty(reason)
       reason = 'Test disabled.';
    end
    result.skipped = reason;
    result.time = 0;
    result.console = '';

% Prepend each line of a multi-line string with the same pretext.
function prepended_text = prepend(text, pretext)

    if isempty(text)
        prepended_text = text;
    else
        lines = mlunit_strsplit(text, char(10));
        % prepend pretext to text, preserving whitespace in pretext
        prepended_lines = strcat({pretext}, lines);
        % preserve a final newline whithout pretext
        if ~isempty(lines) && isempty(lines{end})
            prepended_lines{end} = '';
        end
        prepended_text = mlunit_strjoin(prepended_lines, char(10));
    end

function legacy_stack_handling(err)
        
    % Previous code added some stack if the field was missing.
    % But why would it be missing?
    if (~isfield(err, 'stack'))
        warning('MLUNIT:unexpectedExecution', 'This code seems deprecated, but we did not know when it activated. Please report this bug along with the circumstance in which it occurred.');
%         err.stack(1).file = char(which(method));
%         err.stack(1).line = '1';
%         err.stack = vertcat(err.stack, dbstack('-completenames'));
    end
