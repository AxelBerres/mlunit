function self = test_load_tests_from_test_case(self)
%test_test_loader/test_load_tests_from_test_case tests the method
%test_loader/load_tests_from_test_case.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_test_loader(''test_load_tests_from_test_case'');');
%
%  See also TEST_LOADER/LOAD_TESTS_FROM_TEST_CASE.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_load_tests_from_test_case.m 253 2007-01-27 21:20:20Z thomi $

results = run_suite(mlunit_suite_runner, 'mock_test');
errors = sum(arrayfun(@(e) all(~isempty(e.errors)), results));
failures = sum(arrayfun(@(e) ~isempty(e.failure), results));

assert_equals(3, numel(results));
assert_equals(2, mlunit_num_suite_errors(results));
assert_equals(0, mlunit_num_suite_failures(results));
