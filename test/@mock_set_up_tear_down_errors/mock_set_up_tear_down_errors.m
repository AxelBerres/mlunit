function w = mock_set_up_tear_down_errors(name)
%mock_set_up_tear_down_errors test assert/skip/error behaviour in set_up, tear_down and
%the test.

w.tdown_action = '';
w.setup_action = '';
t = test_case(name);
w = class(w, 'mock_set_up_tear_down_errors', t);
