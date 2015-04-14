function test = test_mat2str_char

test = load_tests_from_mfile(test_loader);

function test_noargs %#ok<DEFNU>
    
    assert_error(@() mat2str_char());

function test_empty_0x0 %#ok<DEFNU>

    assert_equals('''''', mat2str_char(''));
    
function test_empty_1x0 %#ok<DEFNU>

    % construct 1x0 char array
    s = 'a';
    s(1) = [];
    assert_equals('''''', mat2str_char(s));

function test_scalar %#ok<DEFNU>

    assert_equals('''foobar''', mat2str_char('foobar'));

function test_matrix %#ok<DEFNU>

    assert_equals('[''foo'';''bar'']', mat2str_char(['foo';'bar']));

function test_ndims_too_many %#ok<DEFNU>

    s(1,1,1) = 'a';
    s(1,1,2) = 'b';
    assert_error(@() mat2str_char(s));


%% boilerplate code for testing functions that are private to assert functions
function set_up %#ok<DEFNU>

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    
    % buffer current path
    mlunit_param('usertest_mat2strchar', pwd);
    cd(testdir);

function tear_down %#ok<DEFNU>

    % reset to previous dir
    cd(mlunit_param('usertest_mat2strchar'));
