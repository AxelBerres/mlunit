function self = test_suite(self)
%test_test_suite/test_suite tests the basic behaviour of test_suite/run.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_test_suite(''test_suite'');');
%
%  See also TEST_SUITE/RUN.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_suite.m 47 2006-06-11 19:26:32Z thomi $

setup_obj = mock_test('suite_set_up');
teardown_obj = mock_test('suite_tear_down');
suite = mlunit_testsuite('', setup_obj, teardown_obj);

suite = add_test(suite, mock_test('test_method'));
suite = add_test(suite, mock_test('test_broken_method'));

results = cellfun(@(t) run_test(mlunit_suite_runner, t), get_tests(suite));
assert_equals(2, numel(results));
assert_equals(1, mlunit_num_suite_errors(results));
assert_equals(0, mlunit_num_suite_failures(results));
