function test = test_mark_string_differences %#ok<STOUT>

output_tests_from_mfile;

function test_not_two_args %#ok<DEFNU>
    
    assert_error(@() mark_string_differences());
    assert_error(@() mark_string_differences('hi'));
    assert_error(@() mark_string_differences('hi', 'ho', 'hu'));

function test_both_empty %#ok<DEFNU>

    assert_empty(mark_string_differences('', ''));
    assert_empty(mark_string_differences(repmat('a',1,0),repmat('a',0,1)));

function test_one_empty %#ok<DEFNU>

    expected = '^^^';
    actual1 = mark_string_differences('', 'foo');
    actual2 = mark_string_differences('foo', '');
    assert_equals(expected, actual1);
    assert_equals(expected, actual2);

function test_nominal %#ok<DEFNU>

          s1 = 'bard''s';
          s2 = 'burt''s';
    expected = ' ^ ^  ';
    
    actual = mark_string_differences(s1, s2);
    assert_equals(expected, actual);

function test_deletion %#ok<DEFNU>

          s1 = 'I say tomato';
          s2 = 'You say tomato';
    expected = '^^^^^^^^^^^^^^';
    
    actual = mark_string_differences(s1, s2);
    assert_equals(expected, actual);

function test_multiline_string

          s1 =   '[''foo'';''bar'']';
          s2 =   '[''fuh'';''bah'']';
    % actually:   ['fuh';'bah']
    expected =   '   ^^     ^  ';
    actual = mark_string_differences(s1, s2);
    assert_equals(expected, actual);
    

%% boilerplate code for testing functions that are private to assert functions
function set_up %#ok<DEFNU>

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    cd(testdir);
