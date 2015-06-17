function self = test_count_test_cases(self)
%test_test_suite/test_count_test_cases tests the method
%test_suite/count_tests_cases.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_test_suite(''test_count_test_cases'');');
%
%  See also TEST_SUITE/COUNT_TEST_CASES.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_count_test_cases.m 47 2006-06-11 19:26:32Z thomi $

setup_obj = mock_test('suite_set_up');
teardown_obj = mock_test('suite_tear_down');
suite = mlunit_testsuite('', setup_obj, teardown_obj);

assert_equals(0, count_test_cases(suite));
suite = add_test(suite, mock_test('test_method'));
assert_equals(1, count_test_cases(suite));
suite = add_test(suite, mock_test('test_broken_method'));
assert_equals(2, count_test_cases(suite));
