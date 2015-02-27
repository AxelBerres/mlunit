function self = test_fixture(self)
%test_function_test_case/test_fixture tests the fixture of a
%function_test_case with all test methods within on .m-file.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_function_test_case(''test_fixture'')');
%
%  See also TEST_FUNCTION_TEST_CASE.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_fixture.m 41 2006-06-11 18:31:37Z thomi $

test = function_test_case(@() assert_true(1), 0, 0);
result = run_test(mlunit_suite_runner, test);
assert_empty(result.errors);
assert_empty(result.failure);

% change here, so that run_suite sees test_fixture as function
testsuite = load_tests_from_mfile(test_loader);
tests = get_tests(testsuite);
results = cellfun(@(t) run_test(mlunit_suite_runner, t), tests);
assert_equals(2, numel(results));

function set_up  %#ok

global x;
assert_equals([], x);
x = [3 4];

function tear_down %#ok

global x;
x = 0;

function test_norm %#ok

global x;
assert_equals(5, norm(x));

function test_normest %#ok

global x;
assert_equals(5, norm(x));
