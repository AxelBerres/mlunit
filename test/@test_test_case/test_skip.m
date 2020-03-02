function self = test_skip(self)
%test_test_case/test_catch_output tests the behaviour of test_case/run, when
%'catch_output' has been activated

results = run_suite(mlunit_suite_runner, 'mock_test_skip');

assert_equals(3, numel(results));

assert_equals('test_method', results(1).name);
assert_equals('Test skipped during execution.', results(1).skipped(1:30));

assert_equals('test_method_noskip', results(2).name);
assert_equals('', results(2).skipped);

assert_equals('test_method_with_msg', results(3).name);
assert_equals('Substantiated skip', results(3).skipped(1:18));

assert_equals({'', '', ''}, {results.failure});
assert_equals({'', '', ''}, {results.console});
assert_equals({{}, {}, {}}, {results.errors});
