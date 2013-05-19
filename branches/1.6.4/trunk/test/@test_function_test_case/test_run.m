function self = test_run(self)
%test_function_test_case/test_fixture tests the run method of
%function_test_case.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_function_test_case(''test_run'')');
%
%  See also TEST_FUNCTION_TEST_CASE.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_run.m 269 2007-04-02 19:54:39Z thomi $

test = function_test_case(@() assert_true(true));
[test, result] = run(test); %#ok
assert_equals(0, get_failures(result));
assert_equals(0, get_errors(result));
assert_equals(1, get_tests_run(result));

