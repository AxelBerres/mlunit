function test = test_find_struct_differences

test = load_tests_from_mfile(test_loader);


function test_equality

    s = struct('foo', 42);
    assert_empty(find_struct_differences(s, s));
    
function test_equality_emptystruct

    s = struct('foo', {});
    assert_error(@() find_struct_differences(s, s));

function test_equality_emptystruct_nofields

    s = struct([]);
    assert_error(@() find_struct_differences(s, s));

function test_differentFieldOrder

    x = struct('a','','b','');
    y = struct('b','','a','');

    assert_empty(find_struct_differences(x, y));

function test_equalStructArrays

    x = struct('field1', {1 2}, 'field2', {'a', 'c'});
    y = struct('field1', {1 2}, 'field2', {'a', 'c'});

    assert_error(@() find_struct_differences(x, y));

function test_differentFieldnames

    x = struct('a','','b','');
    y = struct('c','','a','');
    
    result = struct( ...
        'fieldpath', {'.b', '.c'}, ...
        'missingin', {'actual', 'expected'}, ...
        'expected', {'', []}, ...
        'actual', {[], ''});

    assert_equals(result, find_struct_differences(x, y));

function test_manyDifferencesNested

    x.a = struct('a','','b','hi');
    x.b = 3;
    x.c = 'foo';
    y.a = struct('b','ho','a','','c','');
    y.c = 'bar';

    result = struct( ...
        'fieldpath', {'.b',     '.a.c',     '.a.b', '.c'}, ...
        'missingin', {'actual', 'expected', '',     ''}, ...
        'expected',  {3,        [],         'hi',   'foo'}, ...
        'actual',    {[],       '',         'ho',   'bar'});

    assert_equals(result, find_struct_differences(x, y));    


%% boilerplate code for testing functions that are private to assert functions
function set_up

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    
    % buffer current path
    mlunit_param('usertest_find_struct', pwd);
    cd(testdir);

function tear_down

    % reset to previous dir
    cd(mlunit_param('usertest_find_struct'));
