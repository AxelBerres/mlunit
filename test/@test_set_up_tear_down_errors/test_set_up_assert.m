function self = test_set_up_assert(self)

results = assert_executionstate(1, 0, 1, 0);

expected_msg = sprintf([...
    'In set_up fixture:\n' ...
    'This is an assert_* call in set_up.' ...
    ]);
expected_len = numel(expected_msg);

actual_msg = get_message_with_stack(results(1).failure);
assert_equals(expected_msg, actual_msg(1:expected_len));
