function self = test_set_up_skip(self)

results = assert_executionstate(3, 0, 0, 1);

expected_msg = sprintf([...
    'In set_up fixture:\n' ...
    'This is a runtime skip request in set_up.' ...
    ]);
expected_len = numel(expected_msg);

actual_msg = get_message_with_stack(results(3).skipped);
assert_equals(expected_msg, actual_msg(1:expected_len));
