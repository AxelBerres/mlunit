function t = test_set_up_tear_down_errors(name)
%test_set_up_tear_down_errors test assert/skip/error behaviour in set_up, tear_down and
%the test.

tc = test_case(name);
t = class(struct(), 'test_set_up_tear_down_errors', tc);
