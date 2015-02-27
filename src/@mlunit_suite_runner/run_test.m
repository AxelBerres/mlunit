%Execute a single test case.
%  RESULT = run_test(SELF, TEST) executes test case TEST.
%  SELF is an mlunit_suite_runner instance. TEST is a test_case instance.
%  TEST must exist.
%  
%  RESULT is a scalar struct with fields:
%    - name    : string, the test case name, mandatory
%    - errors  : struct array, all errors that occurred during execution, each 
%                a struct in itself with fields message and stack,
%                0x0 struct with these fields, if no errors occurred
%    - failure : string, the failure message, empty, if no failure occurred
%    - time    : double, the execution time in seconds
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


%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: load_tests_from_mfile.m 173 2012-06-12 09:26:53Z alexander.roehnsch $

function [result, self, test] = run_test(self, test)

    start_time = clock;

    % buffer environment for reset after each test case
    previous_environment = mlunit_environment();
    
    % execute set_up fixture
    errors = {};
    try
        test = set_up(test);
    catch
        errors{end+1} = mlunit_errorinfo(lasterror, 'Error in set_up fixture:');
    end

    % execute test, only if set_up prevailed
    test_failure = '';
    if isempty(errors)
        method = get_name(test);
        try
            test = eval([method, '(test)']);
        catch
            err = lasterror;
            errorinfo = mlunit_errorinfo(err);
            if is_failure(errorinfo)
                test_failure = get_message_with_stack(errorinfo);
            else
                % Previous code added some stack if the field was missing.
                % But why would it be missing?
                if (~isfield(err, 'stack'))
                    error('MLUNIT:unexpectedExecution', 'This code seems deprecated, but we did not know when it activated. Please report this bug along with the circumstance in which it occurred.');
%                     err.stack(1).file = char(which(method));
%                     err.stack(1).line = '1';
%                     err.stack = vertcat(err.stack, dbstack('-completenames'));
                end

                errors{end+1} = errorinfo;
            end;
        end;
    end;

    % execute tear_down fixture in any case, even if set_up or test failed
    try
        test = tear_down(test);
    catch
        errors{end+1} = mlunit_errorinfo(lasterror, 'Error in tear_down fixture:');
    end

    % restore previous environment after test and fixtures finished
    mlunit_environment(previous_environment);

    % build result structure
    result = struct();
    result.name = get_function_name(test);
    result.errors = errors;
    result.failure = test_failure;
    result.time = etime(clock, start_time);
    
    % update progress listeners with latest test result; keep self updated
    for lidx=1:numel(self.listeners)
        self.listeners{lidx} = next_result(self.listeners{lidx}, result);
    end
