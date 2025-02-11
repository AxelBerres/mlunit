function self = set_up(self)
%function_test_case/set_up calls the set_up_function by the function 
%handle to set up the fixture and is called everytime before 
%a test is executed.
%
%  Example
%  =======
%  set_up is not called directly, but through the method run. Example:
%         test = ... % e.g. created through load_tests_from_mfile
%         [test, result] = run(test); 
%         summary(result)
%
%  See also TEST_CASE, FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if (strcmp(class(self.set_up_function), 'function_handle'))
    
    % We can tolerate varargin arguments, but not varargout.
    % Anonymous functions are varargout by default (nargout == -1), but may not
    % return anything, triggering an error, if we tried to get a return value.
    takes_input = nargin(self.set_up_function) ~= 0;
    gives_output = nargout(self.set_up_function) > 0;

    if takes_input && gives_output
        self.data = self.set_up_function(self.function_name);
    elseif takes_input
        self.set_up_function(self.function_name);
    elseif gives_output
        self.data = self.set_up_function();
    else
        self.set_up_function();
    end
end
