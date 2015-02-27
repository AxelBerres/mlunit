function test = test_failure_output

test = load_tests_from_mfile(test_loader);

% Most of these functions first assert valid expressions.
% However, each test's last expression will fail, and thereby demonstrate the
% relevant failure message.

function test_empty

    assert_empty();
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
    assert_equals('foo', 'fOo');

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

function test_not_equals

    assert_not_equals(3, 4);
    assert_not_equals(3, 3);

function test_error

    % terminate with ; in order to suppress output on command line
    assert_error('3;');

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
