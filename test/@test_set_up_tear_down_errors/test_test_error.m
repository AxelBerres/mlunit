function self = test_test_error(self)

results = assert_executionstate(8, 1, 0, 0);

expected_msg = sprintf([...
    'This is a runtime error in the test.' ...
    ]);
expected_len = numel(expected_msg);
actual_msg = get_message_with_stack(results(8).errors{1});
assert_equals(expected_msg, actual_msg(1:expected_len));
