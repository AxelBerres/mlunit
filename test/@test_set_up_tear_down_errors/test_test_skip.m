function self = test_test_skip(self)

results = assert_executionstate(9, 0, 0, 1);

expected_msg = sprintf([...
    'This is a runtime skip request in the test.' ...
    ]);
expected_len = numel(expected_msg);

actual_msg = get_message_with_stack(results(9).skipped);
assert_equals(expected_msg, actual_msg(1:expected_len));
