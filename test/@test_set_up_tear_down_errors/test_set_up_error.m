function self = test_set_up_error(self)

results = assert_executionstate(2, 1, 0, 0);

expected_msg = sprintf([...
    'Error in set_up fixture:\n' ...
    'This is a runtime error in set_up.' ...
    ]);
expected_len = numel(expected_msg);
actual_msg = get_message_with_stack(results(2).errors{1});
assert_equals(expected_msg, actual_msg(1:expected_len));
