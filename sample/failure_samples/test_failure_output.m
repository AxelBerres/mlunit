function test = test_failure_output %#ok<STOUT>

output_tests_from_mfile;

% Most of these functions first assert valid expressions.
% However, each test's last expression will fail, and thereby demonstrate the
% relevant failure message.

function test_empty

    assert_empty([]);
    assert_empty([3]);

function test_not_empty

    assert_not_empty([3]);
    assert_not_empty([]);

function test_false

    assert_false(false);
    assert_false(true);

function test_true

    assert_true(true);
    assert_true(false);

function test_fail

    mlunit_fail('This some custom fail message');

function test_equals

    assert_equals(3, 3);
    assert_equals(3, 4);
    
function test_equals_double_empty

    assert_equals(repmat(3, 1, 0), 3);

function test_equals_array

    arr = 1:16;
    assert_equals(arr, arr);
    assert_equals(arr, [1:9 10.000001 11:15]);

function test_equals_arraymatrix

    arr = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16];
    arr2 = arr;
    arr2(3,2) = 10.000001;
    assert_equals(arr, arr);
    assert_equals(arr, arr2);

function test_equals_string

    assert_equals('foo', 'foo');
    assert_equals('foo', 'fOO');
    
function test_equals_scalar_cellstring

    assert_equals({'foo'}, {'foo'});
    assert_equals({'foo'}, {'fOO'});
    
function test_equals_multiline_string

    expected =   ['foo';'bar'];
    actual =   ['fuh';'bah'];
    assert_equals(expected, actual);

function test_equals_multiline_string_asymmetric

    expected = ['foo';'bar'];
    actual = ['fool';'barz'];
    assert_equals(expected, actual);

function test_equals_multiline_string_vs_singleline

    expected = ['foo';'bar'];
    actual = 'fool;bar';
    assert_equals(expected, actual);
    
function test_equals_cell

    c = {3, 'foo'};
    d = {3, 'fOo'};
    assert_equals(c, c);
    assert_equals(c, d);

function test_equals_struct

    s = struct('foo', {{'hi', 'ho'}}, 'bar', {[3 4]});
    s2 = s;
    s2.foo = {'ho', 'hi'};
    assert_equals(s, s);
    assert_equals(s, s2);

function test_equals_string_struct

    tomahto = 'you say \to-''mah-(,)to';
    tomeyto = 'you say \to-''mey-(,)to';
    s = struct('foo', {tomahto}, 'bar', {[3 4]});
    s2 = s;
    s2.foo = tomeyto;
    assert_equals(s, s);
    assert_equals(s, s2);

function test_equals_scalar_cellstring_struct

    tomahto = 'you say \to-''mah-(,)to';
    tomeyto = 'you say \to-''mey-(,)to';
    s = struct('foo', {{tomahto}}, 'bar', {[3 4]});
    s2 = s;
    s2.foo = {tomeyto};
    assert_equals(s, s);
    assert_equals(s, s2);
        
function test_equals_nested_struct

    s = struct('foo', {{'hi', 'ho'}}, 'bar', {[3 4]});
    s.tee = s;
    s2 = s;
    s2.tee.foo = {'ho', 'hi'};
    assert_equals(s, s);
    assert_equals(s, s2);

function test_equals_nested_struct_multiple_differences

    s = struct('foo', {{'hi', 'ho'}}, 'bar', {[3 4]});
    s.tee = s;
    s2 = s;
    s2.tee.foo = {'ho', 'hi'};
    s2.tee.bar = [3 5];
    assert_equals(s, s);
    assert_equals(s, s2);

function test_equals_nested_struct_many_differences

    s = struct('foo', {{'hi', 'ho'}}, 'bar', {[3 4]});
    s.tee = s;
    s2 = s;
    s2.foo = 42;
    s2.bar(2) = 5;
    s2.tee.foo = {'ho', 'hi'};
    s2.tee.bar = [3 5];
    assert_equals(s, s);
    assert_equals(s, s2);
    
function test_equals_structarray

    s = struct('foo', {{'hi', 'ho'}}, 'bar', {3 4});
    s2 = s;
    s2(2).foo = {'ho', 'hi'};
    assert_equals(s, s);
    assert_equals(s, s2);
    
function test_equals_object
    
    % construct a timeseries object for comparison
    t = timeseries(1:12);
    t2 = t;
    d = get(t2, 'Data');
    d(12) = 13;
    set(t2, 'Data', d);
    assert_equals(t, t2);

function test_equals_handle

    % 0 is the root graphic object's handle, always present
    h = 0;
    f = figure();
    
    assert_true(ishandle(h));
    assert_true(ishandle(f));
    
    % temporarily catch any assert_equals errors and rethrow them only after
    % we closed the figure
    err = struct([]);
    try
        assert_equals(h, f);
    catch
        err = lasterror;
    end
    
    close(f);
    if ~isempty(err)
        rethrow(err)
    end

function test_equals_functionhandle

    fh1 = @(x) x*x+x;
    fh2 = @(x) x+x*x;
    assert_true(isa(fh1, 'function_handle'));
    assert_true(isa(fh2, 'function_handle'));
    assert_equals(fh1, fh2);

function test_equals_javaobject

    jo = java.lang.String('hiho');
    jo2 = java.lang.String('hiHo');
    assert_equals(jo, jo2);

function test_not_equals

    assert_not_equals(3, 4);
    assert_not_equals(3, 3);

function test_error

    % terminate with ; in order to suppress output on command line
    assert_error('3;', struct(), 'Should be error, but %i alone isn''t.', 3);

function test_typed_error

    f = @() 3;
    assert_error(f, 'MATLAB:SomeError');

function test_wrong_typed_error

    assert_error('()', 'MATLAB:SomeError');

function test_warning

    wrongpath = 'arbitrary/path/that/should/not/exist';
    assert_warning(@() rmpath(wrongpath), 'MATLAB:rmpath:DirNotFound');
    assert_warning(@() 3, 'MATLAB:rmpath:DirNotFound');

function test_implementation_fault

    unknown_function_call();

function test_nested_functions

    loc_delegated_assert();

function loc_delegated_assert

    mlunit_fail('Nested function test.');
