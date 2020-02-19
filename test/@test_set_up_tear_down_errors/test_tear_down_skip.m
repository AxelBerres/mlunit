function self = test_tear_down_skip(self)

results = assert_executionstate(6, 1, 0, 0);

expected_msg = sprintf([...
    'Skipping is not possible in tear_down fixture:\n' ...
    'This is a runtime skip request in tear_down.' ...
    ]);
expected_len = numel(expected_msg);
actual_msg = get_message_with_stack(results(6).errors{1});
assert_equals(expected_msg, actual_msg(1:expected_len));
