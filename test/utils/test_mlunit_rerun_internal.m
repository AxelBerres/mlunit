% Test some of mlunit_rerun's logic.
function test = test_mlunit_rerun_internal

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>


% Tests for getNextErrorOrFail
function test_nextissue_invalid_issuename
    assert_error(@()loc_getNextErrorOrFail([], [], []));
    
function test_nextissue_invalid_issuenumber
    assert_error(@()loc_getNextErrorOrFail([], [], 'failure'), 'MATLAB:badsubscript');
    
function test_nextissue_empty
    actual = loc_getNextErrorOrFail([], 0, 'failure');
    assert_equals([0, 0], actual);

function test_nextissue_first_failure
    actual = loc_getNextErrorOrFail(stub_suiteresult(), 0, 'failure');
    assert_equals([1, 2], actual);
    
function test_nextissue_next_failures
    actual = loc_getNextErrorOrFail(stub_suiteresult(), [1, 2], 'failure');
    assert_equals([1, 3], actual);

    actual = loc_getNextErrorOrFail(stub_suiteresult(), [1, 3], 'failure');
    assert_equals([2, 1], actual);

    actual = loc_getNextErrorOrFail(stub_suiteresult(), [2, 1], 'failure');
    assert_equals([2, 3], actual);

function test_nextissue_first_error
    actual = loc_getNextErrorOrFail(stub_suiteresult(), 0, 'error');
    assert_equals([2, 1], actual);

function test_nextissue_last_failure

    actual = loc_getNextErrorOrFail(stub_suiteresult(), [2, 3], 'failure');
    assert_equals([0, 0], actual);

function test_nextissue_last_error

    actual = loc_getNextErrorOrFail(stub_suiteresult(), [2, 1], 'error');
    assert_equals([0, 0], actual);
    

% Tests for getPriorIssue
function test_priorissue_allinvalid

    assert_equals(0, loc_getPriorIssue(0, 0));
    
function test_priorissue_oneinvalid

    assert_equals([3, 4], loc_getPriorIssue(0, [3, 4]));
    assert_equals([3, 4], loc_getPriorIssue([3, 4], 0));
    
function test_priorissue_smallermajor

    assert_equals([3, 4], loc_getPriorIssue([4, 3], [3, 4]));
    assert_equals([3, 4], loc_getPriorIssue([3, 4], [4, 3]));

function test_priorissue_smallerminor

    assert_equals([3, 4], loc_getPriorIssue([3, 5], [3, 4]));
    assert_equals([3, 4], loc_getPriorIssue([3, 4], [3, 5]));

    
% Delegators and stubs
function nextIssue = loc_getNextErrorOrFail(suiteresults, currentIssue, issueName)

    funchandle = mlunit_get_subfunction_handle('mlunit_rerun', 'loc_getNextErrorOrFail');
    nextIssue = feval(funchandle, suiteresults, currentIssue, issueName);
    
function priorIssue = loc_getPriorIssue(kim, sam)

    funchandle = mlunit_get_subfunction_handle('mlunit_rerun', 'loc_getPriorIssue');
    priorIssue = feval(funchandle, kim, sam);
    
function s = stub_suiteresult()

    s{1}.testcaseList{1}.failure = '';
    s{1}.testcaseList{1}.error = '';

    s{1}.testcaseList{2}.failure = 'failed';
    s{1}.testcaseList{2}.error = '';

    s{1}.testcaseList{3}.failure = 'failed';
    s{1}.testcaseList{3}.error = '';

    s{2}.testcaseList{1}.failure = 'failed';
    s{2}.testcaseList{1}.error = 'broken';

    s{2}.testcaseList{2}.failure = '';
    s{2}.testcaseList{2}.error = '';

    s{2}.testcaseList{3}.failure = 'failed';
    s{2}.testcaseList{3}.error = '';
   
    s{3}.testcaseList{1}.failure = '';
    s{3}.testcaseList{1}.error = '';
