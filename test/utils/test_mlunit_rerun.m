% Test mlunit_rerun.
function test = test_mlunit_rerun

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function suite_set_up

    % Run mock test suite once, and save its suiteresults data for usage in tests.
    run_suite_collection(mlunit_suite_runner, 'mock_test_mlunit_rerun');
    mlunit_param('suitedata', loc_cache('data'));

function test_norun_all_default
    mlunit_rerun('save', struct('suiteresults', {{}}, 'testobj', {''}));

    text = evalc('mlunit_rerun');
    assert_contains(text, 'Rerunning all previously executed tests.');
    assert_contains(text, 'Executed 0 tests across 0 suites');
    
function test_norun_next
    mlunit_rerun('save', struct('suiteresults', {{}}, 'testobj', {''}));

    text = evalc('mlunit_rerun(''next'')');
    assert_contains(text, 'There are no further issues available.');

function test_norun_current
    mlunit_rerun('save', struct('suiteresults', {{}}, 'testobj', {''}));

    assert_error(@()mlunit_rerun('current'), 'MLUNIT:currentSingleResult');

function test_run_remaining_default
    mlunit_rerun('save', mlunit_param('suitedata'));
    
    text = evalc('mlunit_rerun');
    assert_contains(text, 'Rerunning remaining issues.');
    assert_contains(text, 'Executed 3 tests across 1 suite');
    assert_contains(text, '2 tests FAILED');
    assert_contains(text, '1 test had ERRORS');

function test_run_remaining_errors
    mlunit_rerun('save', mlunit_param('suitedata'));
    
    text = evalc('mlunit_rerun(''errors'')');
    assert_contains(text, 'test_error ERROR:');
    assert_contains(text, 'Executed 1 test across 1 suite');
    assert_contains(text, '1 test had ERRORS');

    
function test_run_next_workflow
    mlunit_rerun('save', mlunit_param('suitedata'));
    
    assert_error(@()mlunit_rerun('current'), 'MLUNIT:currentSingleResult');
    
    text = evalc('mlunit_rerun(''next'')');
    assert_contains(text, 'test_fail FAIL');
    assert_contains(text, 'Executed 1 test across 1 suite');
    assert_contains(text, '1 test FAILED');
    
    text = evalc('mlunit_rerun(''current'')');
    assert_contains(text, 'test_fail FAIL');
    assert_contains(text, 'Executed 1 test across 1 suite');
    assert_contains(text, '1 test FAILED');
    
    text = evalc('mlunit_rerun(''next'')');
    assert_contains(text, 'test_error ERROR');
    assert_contains(text, 'Executed 1 test across 1 suite');
    assert_contains(text, '1 test had ERRORS');
    
    text = evalc('mlunit_rerun(''forget'')');
    assert_contains(text, 'Forgot the currently selected test.');
    
    assert_error(@()mlunit_rerun('current'), 'MLUNIT:currentSingleResult')

    
function test_run_next_error_endoflist
    mlunit_rerun('save', mlunit_param('suitedata'));
    
    text = evalc('mlunit_rerun(''nexterror'')');
    assert_contains(text, 'test_error ERROR');
    assert_contains(text, 'Executed 1 test across 1 suite');
    assert_contains(text, '1 test had ERRORS');
    
    text = evalc('mlunit_rerun(''nexterror'')');
    assert_contains(text, 'You''re at the end of errors.');
    
    assert_error(@()mlunit_rerun('current'), 'MLUNIT:currentSingleResult')
    

% Delegators
function output = loc_cache(flag, input)

    funchandle = mlunit_get_subfunction_handle('mlunit_rerun', 'loc_cache');
    if nargin == 1
        output = feval(funchandle, flag);
    else
        output = feval(funchandle, flag, input);
    end
