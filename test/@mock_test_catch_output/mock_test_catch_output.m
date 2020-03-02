function w = mock_test_catch_output(name)
%mock_test_catch_output is a mock test_case to test test output
%
%  Example
%  =======
%         run(mlunit_gui, 'mock_test_catch_output(''test_method'')');

w.dummy = 0;
t = test_case(name);
w = class(w, 'mock_test_catch_output', t);
