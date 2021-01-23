function test = mock_test_mlunit_rerun

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function test_pass
    assert_true;
    
function test_fail
    assert_false;
    
function test_error
    error('uh:huh', 'Uh huh');

function test_skip
    mlunit_skip('whatever');
    
function test_fail2
    assert_false;

function test_pass2
    assert_true;
