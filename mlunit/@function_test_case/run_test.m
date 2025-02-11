function self = run_test(self)
%function_test_case/run_test calls the test_function by the function 
%handle.
%
%  Example
%  =======
%  Usually run_test (as every test method) is not called directly, but
%  through the method run. Example:
%         test = function_test_case(@() assert_true(0 == sin(0)));
%         [test, result] = run(test); 
%         summary(result)
%
%  See also TEST_CASE, FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if isa(self.test_function, 'function_handle') % Could be 0 for non-defined suite_setup and suite_teardown

    % We can tolerate varargin arguments, but not varargout.
    % Anonymous functions are varargout by default (nargout == -1), but may not
    % return anything, triggering an error, if we tried to get a return value.
    takes_input = nargin(self.test_function) ~= 0;
    gives_output = nargout(self.test_function) > 0;

    if takes_input && gives_output
        self.data = self.test_function(self.data);
    elseif takes_input
        self.test_function(self.data);
    elseif gives_output
        self.data = self.test_function();
    else
        self.test_function();
    end
end
