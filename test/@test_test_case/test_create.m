function self = test_create(self)
%test_test_case/test_create tests the constructor of test_case.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_test_case(''test_creates'');');
%
%  See also TEST_CASE.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_create.m 44 2006-06-11 18:54:09Z thomi $

assert_error(@() test_case('foo', 'mock_test'));
assert_error(@() test_case('', 'mock_test'));
