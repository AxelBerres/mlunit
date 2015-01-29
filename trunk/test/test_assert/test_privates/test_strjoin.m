function test = test_strjoin

test = load_tests_from_mfile(test_loader);

function test_empty

    assert_equals('', strjoin());
    assert_equals('', strjoin({}));
    assert_equals('', strjoin({''}));
    assert_equals('', strjoin({'', ''}, ''));
    
function test_empty_separator

    assert_equals('abc', strjoin({'a', 'b', 'c'}, ''));
    
function test_default_separator

    assert_equals('a, b, c', strjoin({'a', 'b', 'c'}));
    
function test_nominal
    
    assert_equals('a;b;c', strjoin({'a', 'b', 'c'}, ';'));

function test_multichar_separator
    
    assert_equals('a::b::c', strjoin({'a', 'b', 'c'}, '::'));
    assert_equals('a', strjoin({'a'}, '::'));

function test_wrong_list_type

    assert_error(@() strjoin('abc'), 'MATLAB:assert:failed');
    assert_error(@() strjoin(3), 'MATLAB:assert:failed');
    assert_error(@() strjoin([]), 'MATLAB:assert:failed');

function test_wrong_separator_type

    assert_error(@() strjoin({'abc'}, 3), 'MATLAB:assert:failed');
    assert_error(@() strjoin({'abc'}, []), 'MATLAB:assert:failed');
    assert_error(@() strjoin({'abc'}, {','}), 'MATLAB:assert:failed');


%% boilerplate code for testing functions that are private to assert functions
function set_up

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    
    % buffer current path
    mlunit_param('usertest_strjoin', pwd);
    cd(testdir);

function tear_down

    % reset to previous dir
    cd(mlunit_param('usertest_strjoin'));
