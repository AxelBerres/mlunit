function test = test_assert_error %#ok<STOUT>

output_tests_from_mfile;


function test_proper_errors %#ok<DEFNU>

    % any error, resulting from wrong error call
    assert_error('error');
    assert_error(@() error()); %#ok<LTARG>

    % by id, resulting from wrong error call
    assert_error('error', 'MATLAB:minrhs');
    assert_error(@() error(), 'MATLAB:minrhs'); %#ok<LTARG>

    % by id, resulting from valid error call
    assert_error('error(''huh:ha'', '''');', 'huh:ha');
    assert_error(@() error('huh:ha', ''), 'huh:ha');

    % by other fields, resulting from valid error call
    assert_error('error(''huh\nha'');', struct('message', 'huh\nha'));
    assert_error('error(''huh\nha'');', struct('message', 'huh\nha', 'identifier', ''));
    assert_error(@() error('huh\nha'), struct('message', 'huh\nha', 'identifier', ''));

    % btw, error() without id does not sprintf its message, but error() with id does:
    assert_error(@() error('my:id', 'huh\nha'), struct('message', sprintf('huh\nha'), 'identifier', 'my:id'));

    % by other field message, resulting from valid error call that is nested somewhat deeper
    assert_error(@proxy_deep_stack_error, struct('message', 'Still waters run deep.'));

    % with variable injection
    v1 = 3; v2 = {};
    if verLessThan('matlab', '9.3')
        assert_error(@() max(v1, v2), 'MATLAB:UndefinedFunction');
    else
        assert_error(@() max(v1, v2), 'MATLAB:max:wrongSecondInput');
    end


function proxy_deep_stack_error

    proxy_deep_stack_error_nested();

function proxy_deep_stack_error_nested

    error('Still waters run deep.');

% Deactivated test.
% Stack conformity should not be tested. The stack,
% and this test's result with it, will depend on the calling instance,
% i.e. whether the tests were started by calling recursive_test_run,
% or by some wrapper script.
function notest_proper_error_by_stack

    % only include function names, as they should be pretty stable across
    % different machines and different revisions
    names = { ...
        'proxy_deep_stack_error_nested'; ...
        'proxy_deep_stack_error'; ...
        'assert_error'; ...
        'test_proper_error_by_stack'; ...
        'run_test'; ...
        'run'; ...
        'run'; ...
        'runTestsuite'; ...
        'recursive_test_run'; ...
    };

    expected_stack = struct('name', names);

    assert_error(@proxy_deep_stack_error, struct('stack', expected_stack), 'This may fail when not called via recursive_test_run. E.g. fails when being called by mlunit_test(), which is ok.');


function test_noargs %#ok<DEFNU>

    bCaught = false;

    try
        assert_error();
    catch
        bCaught = true;
        l = lasterror();
        assert_equals('MATLAB:NotEnoughInputs', l.identifier);
    end

    if ~bCaught, mlunit_fail(); end


function test_wrong_id %#ok<DEFNU>

    bCaught = false;

    try
        assert_error(@() error(), 'wrong:id'); %#ok<LTARG>
    catch
        bCaught = true;
        l = lasterror();
        assert_not_empty(strfind(l.message, 'Expected error identifier ''wrong:id'' actually was ''MATLAB:minrhs''.'));
    end

    if ~bCaught, mlunit_fail(); end


function test_field_mismatch %#ok<DEFNU>

    bCaught = false;

    try
        assert_error(@() error('huh\nha'), struct('message', 'wrong message', 'identifier', 'wrong:id'));
    catch
        bCaught = true;
        l = lasterror();
        assert_not_empty(strfind(l.message, 'Expected error identifier ''wrong:id'' actually was ''''.'), ['Could not find expected error message in: ' l.message]);
        assert_not_empty(strfind(l.message, 'Expected error message ''wrong message'' actually was ''huh\nha''.'), ['Could not find expected error message in: ' l.message]);
    end

    if ~bCaught, mlunit_fail(); end
