function self = suite_set_up(self)

% some tests actually compare the error output stack
mlunit_param('linked_trace', 0);

results = run_suite(mlunit_suite_runner, 'mock_set_up_tear_down_errors');
mlunit_param('test_mlunit_set_up_tear_down_errors', results);
