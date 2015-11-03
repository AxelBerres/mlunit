function test = test_strrep_first %#ok<STOUT>

output_tests_from_mfile;

function test_empty %#ok<DEFNU>
    
    expected = '';
    result = strrep_first('', 'foo', 'bar');
    assert_equals(expected, result);

function test_replacement_on_first_position %#ok<DEFNU>

    expected = 'foobar';
    result = strrep_first('barbar', 'bar', 'foo');
    assert_equals(expected, result);

function test_no_replacement_on_second_position %#ok<DEFNU>

    expected = 'bbarbar';
    result = strrep_first('bbarbar', 'bar', 'foo');
    assert_equals(expected, result);
    
function test_no_replacement_if_not_exact %#ok<DEFNU>

    expected = 'baRbar';
    result = strrep_first('baRbar', 'bar', 'foo');
    assert_equals(expected, result);

function test_empty_offender_prefixes %#ok<DEFNU>

    expected = 'foobar';
    result = strrep_first('bar', '', 'foo');
    assert_equals(expected, result);

    
function test_cell_mixed_matches %#ok<DEFNU>

    % base and expected
    data = {...
        '',         ''; ...
        'bar',      'foo'; ...
        'barbar',   'foobar'; ...
        ' bar',     ' bar'; ...
        'baR',      'baR'; ...
    };
    
    result = strrep_first(data(:,1), 'bar', 'foo');
    assert_equals(data(:,2), result);


%% boilerplate code for testing private functions
function set_up %#ok<DEFNU>

    classdir = fileparts(which('mlunit_suite_runner'));
    testdir = fullfile(classdir, 'private');
    cd(testdir);
