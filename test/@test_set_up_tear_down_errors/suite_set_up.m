function self = suite_set_up(self)

results = run_suite(mlunit_suite_runner, 'mock_set_up_tear_down_errors');
mlunit_param('test_mlunit_set_up_tear_down_errors', results);
