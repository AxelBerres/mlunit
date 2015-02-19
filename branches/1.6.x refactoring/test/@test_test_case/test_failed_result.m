function self = test_failed_result(self)
%test_test_case/test_failed_result tests the behaviour of test_case/run, if
%the test method fails.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_test_case(''test_failed_result'');');
%
%  See also TEST_CASE/RUN.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_failed_result.m 44 2006-06-11 18:54:09Z thomi $

test = mock_test('test_broken_method');
[result, test] = run_test(mlunit_suite_runner, test);
assert_equals('set_up tear_down ', get_log(test));
