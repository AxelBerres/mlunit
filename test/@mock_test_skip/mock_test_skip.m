function w = mock_test_skip(name)
%mock_test_skip is a mock test_case to test skipping
%
%  Example
%  =======
%         run(mlunit_gui, 'mock_test_skip(''test_method'')');

w.dummy = 0;
t = test_case(name);
w = class(w, 'mock_test_skip', t);
