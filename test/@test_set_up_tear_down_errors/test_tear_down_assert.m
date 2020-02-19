function self = test_tear_down_assert(self)

results = assert_executionstate(4, 1, 0, 0);

expected_msg = sprintf([...
    'Assertion failed in tear_down fixture, which is not allowed and treated as error:\n' ...
    'This is an assert_* call in tear_down.' ...
    ]);
expected_len = numel(expected_msg);
actual_msg = get_message_with_stack(results(4).errors{1});
assert_equals(expected_msg, actual_msg(1:expected_len));
