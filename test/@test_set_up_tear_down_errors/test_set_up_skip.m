function self = test_set_up_skip(self)

results = assert_executionstate(3, 0, 0, 1);

expected_msg = sprintf([...
    'In set_up fixture:\n' ...
    'This is a runtime skip request in set_up.' ...
    ]);
expected_len = numel(expected_msg);
assert_equals(expected_msg, results(3).skipped(1:expected_len));
