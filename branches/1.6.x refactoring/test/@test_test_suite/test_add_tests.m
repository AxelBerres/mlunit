function self = test_add_tests(self)
%test_test_suite/test_add_tests tests the method test_suite/add_tests.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_test_suite(''test_add_tests'');');
%
%  See also test_add_tests.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_add_tests.m 47 2006-06-11 19:26:32Z thomi $

suite = mlunit_testsuite;

tests{1} = mock_test('test_method');
tests{2} = mock_test('test_broken_method');
suite = add_test(suite, tests{1});
suite = add_test(suite, tests{2});

results = cellfun(@(t) run_test(mlunit_suite_runner, t), get_tests(suite));
assert_equals(2, numel(results));
assert_equals(1, mlunit_num_suite_errors(results));
assert_equals(0, mlunit_num_suite_failures(results));
