function test = test_pass %#ok<STOUT>
%test_assert/test_pass tests valid assertions.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_pass');
%
%  See also ASSERT_TRUE, ASSERT_EQUALS, ASSERT_NOT_EQUALS.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_fail.m 269 2007-04-02 19:54:39Z thomi $

output_tests_from_mfile;

function test_assert_true
% Without message
assert_true(true);
assert_true(sin(pi/2) == cos(0));

% With message
assert_true(true, 'Assertion must pass, so message is never seen.');


function test_assert_equals
% Equals
assert_equals(1, 1);
assert_equals('Foo', 'Foo');
assert_equals([1 2 3], [1 2 3]);
assert_equals(sin(1), sin(1));
assert_equals(true, true);

% Equals with tolerance
assert_equals(101, 106, 5);
assert_equals(0.1+0.2, 0.3, eps(0.3));
assert_equals(0.01, 1-0.99, eps(1));
assert_equals('bar', 'bar', 5);


function test_assert_not_equals
% Not equals
assert_not_equals(0, 1)
assert_not_equals('Foo', 'Bar');
assert_not_equals([1 2 3], [4 5 6]);
assert_not_equals(sin(0), sin(1));
assert_not_equals(true, false);
