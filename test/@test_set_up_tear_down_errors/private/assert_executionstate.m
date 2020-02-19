function results = assert_executionstate(idxTest, nErrors, bAssert, bSkip)

    results = mlunit_param('test_mlunit_set_up_tear_down_errors');
    
    stack = dbstack();
    assert_equals(stack(2).name, results(idxTest).name, 'Mock test and actual test name do not match.');
    
    assert_equals(nErrors, numel(results(idxTest).errors));
    assert_equals(bAssert, ~isempty(results(idxTest).failure));
    assert_equals(bSkip, ~isempty(results(idxTest).skipped));