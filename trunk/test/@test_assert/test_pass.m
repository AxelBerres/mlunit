function self = test_pass(self)
%test_assert/test_pass tests valid assertions.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%
%  See also ASSERT_TRUE, ASSERT_EQUALS, ASSERT_NOT_EQUALS.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_pass.m 269 2007-04-02 19:54:39Z thomi $

% Without message
assert_true(true);
assert_true(sin(pi/2) == cos(0));

% With message
assert_true(true, 'Assertion must pass, so message is never seen.');

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

% Not equals
assert_not_equals(0, 1)
assert_not_equals('Foo', 'Bar');
assert_not_equals([1 2 3], [4 5 6]);
assert_not_equals(sin(0), sin(1));
assert_not_equals(true, false);