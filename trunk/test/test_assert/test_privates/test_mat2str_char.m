function test = test_mat2str_char

test = load_tests_from_mfile(test_loader);

function test_noargs
    
    assert_error(@() mat2str_char());

function test_empty_0x0

    assert_equals('''''', mat2str_char(''));
    
function test_empty_1x0

    % construct 1x0 char array
    s = 'a';
    s(1) = [];
    assert_equals('''''', mat2str_char(s));

function test_scalar

    assert_equals('''foobar''', mat2str_char('foobar'));

function test_matrix

    assert_equals('[''foo'';''bar'']', mat2str_char(['foo';'bar']));

function test_ndims_too_many

    s(1,1,1) = 'a';
    s(1,1,2) = 'b';
    assert_error(@() mat2str_char(s));


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
