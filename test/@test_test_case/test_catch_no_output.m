function self = test_catch_no_output(self)
%test_test_case/test_catch_no_output tests the behaviour of test_case/run, when
%'catch_output' has been deactivated

mlunit_param('catch_output', false);

test = mock_test_catch_output('test_method');
[result, dummy, test] = run_test(mlunit_suite_runner, test);

assert_empty(result.console);
