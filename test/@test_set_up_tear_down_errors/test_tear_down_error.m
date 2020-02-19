function self = test_tear_down_error(self)

results = assert_executionstate(5, 1, 0, 0);

expected_msg = sprintf([...
    'Error in tear_down fixture:\n' ...
    'This is a runtime error in tear_down.' ...
    ]);
expected_len = numel(expected_msg);
actual_msg = get_message_with_stack(results(5).errors{1});
assert_equals(expected_msg, actual_msg(1:expected_len));
