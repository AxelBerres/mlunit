% Test mlunit_single
function test = test_mlunit_single

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function test_single_test
    text = evalc('mlunit_single(''test_mlunit_param.test_single_undefined'')');
    assert_contains(text, 'Running suite test_mlunit_param');
    assert_contains(text, 'Executed 1 test across 1 suite');
    assert_contains(text, 'SUCCESS');

function test_missing_test
    text = evalc('mlunit_single(''test_mlunit_param.test_does_not_exist'')');
    assert_contains(text, 'Running suite test_mlunit_param');
    assert_contains(text, 'Executed 0 tests across 1 suite');
    assert_contains(text, 'SUCCESS');
    
function test_missing_suite
    assert_error(@()mlunit_single('test_foobar.test_foobar'), 'MLUNIT:invalidTestobj');

function test_invalid_argument
    assert_error(@()mlunit_single(''), 'MLUNIT:inputString');
    assert_error(@()mlunit_single('foobar'), 'MLUNIT:inputString');
    assert_error(@()mlunit_single('a.b.c'), 'MLUNIT:inputString');
