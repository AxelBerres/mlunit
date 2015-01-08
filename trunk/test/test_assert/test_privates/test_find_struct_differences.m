function test = test_find_struct_differences

test = load_tests_from_mfile(test_loader);


function test_equality

    s = struct('foo', 42);
    assert_empty(find_struct_differences(s, s));
    
function test_equality_emptystruct

    s = struct('foo', {});
    assert_error(@() find_struct_differences(s, s), 'MATLAB:assert:failed');

function test_equality_emptystruct_nofields

    s = struct([]);
    assert_error(@() find_struct_differences(s, s), 'MATLAB:assert:failed');

function test_differentFieldOrder

    x = struct('a','','b','');
    y = struct('b','','a','');

    assert_empty(find_struct_differences(x, y));

function test_equalStructArrays

    x = struct('field1', {1 2}, 'field2', {'a', 'c'});
    y = struct('field1', {1 2}, 'field2', {'a', 'c'});

    assert_error(@() find_struct_differences(x, y), 'MATLAB:assert:failed');

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
    loc_path_capsule(pwd);
    
    cd(testdir);

function tear_down

    % reset to previous dir
    cd(loc_path_capsule());

% Return last stored path string. Empty string if none stored.
% Provide path string argument for storage. If used with argument,
% the returned path is the previous path.
function pout = loc_path_capsule(pin)

    assert(nargin==0 || ischar(pin));

    persistent stored_path;
    if isempty(stored_path)
        stored_path = '';
    end
    
    pout = stored_path;
    
    if nargin >= 1
        stored_path = pin;
    end
