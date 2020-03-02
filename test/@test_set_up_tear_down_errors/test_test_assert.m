function self = test_test_assert(self)

results = assert_executionstate(7, 0, 1, 0);

expected_msg = sprintf([...
    'This is an assert_* call in the test.' ...
    ]);
expected_len = numel(expected_msg);
assert_equals(expected_msg, results(7).failure(1:expected_len));
