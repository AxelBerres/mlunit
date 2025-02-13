function test = test_matlab_test_failures

test = load_tests_from_mfile(test_loader);


%% Fixtures
function suite_set_up

    % Keep the failing MATLAB unit test in a protected folder, so that mlUnit
    % testing isn't affected.
    % Make it testable only for this particular test.
    movefile private testfolder

function suite_tear_down

    movefile testfolder private


%% Tests
function test_matlab_test_failures_errors
    
    % Run a MATLAB unit test suites containing errors and failures
    run_suite_collection(mlunit_suite_runner, 'testfolder');

    % Abuse mlunit_rerun to access the internal test results.
    suiteresults = loc_get_suiteresult();

    % Check general numbers.
    assert_equals(1, numel(suiteresults));
    assert_equals(4, numel(suiteresults{1}.testcaseList));

    assert_equals(4, suiteresults{1}.tests);
    assert_equals(1, suiteresults{1}.errors);
    assert_equals(1, suiteresults{1}.failures);
    assert_equals(1, suiteresults{1}.skipped);

    assert_equals('demonstrateFailure', suiteresults{1}.testcaseList{1}.name);
    assert_not_empty(suiteresults{1}.testcaseList{1}.failure);

    assert_equals('demonstrateError', suiteresults{1}.testcaseList{2}.name);
    assert_not_empty(suiteresults{1}.testcaseList{2}.error);

    assert_equals('demonstratePass', suiteresults{1}.testcaseList{3}.name);
    assert_empty(suiteresults{1}.testcaseList{3}.failure);
    assert_empty(suiteresults{1}.testcaseList{3}.error);
    assert_empty(suiteresults{1}.testcaseList{3}.skipped);

    assert_equals('demonstrateSkip', suiteresults{1}.testcaseList{4}.name);
    assert_not_empty(suiteresults{1}.testcaseList{4}.skipped);


%% Helpers
function results = loc_get_suiteresult()

    funchandle = mlunit_get_subfunction_handle('mlunit_rerun', 'loc_cache');
    output = feval(funchandle, 'data');
    results = output.suiteresults;
