function self = call_with_data(self, function_handle)
%function_test_case/call_with_data is used internally.
%
%  It provides a generic way to call either set_up, the test, or tear_down
%  and handles input/output argument for data exchange between these calls.
%
%  See also FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if (strcmp(class(function_handle), 'function_handle')) % Could be 0 for non-defined suite_setup and suite_teardown
    
    num_argin = nargin(function_handle);
    num_argout = nargout(function_handle);

    % We can tolerate varargin arguments, but not varargout.
    % Anonymous functions are varargout by default (nargout == -1), but may not
    % return anything, triggering an error, if we tried to get a return value.
    takes_input_data = num_argin ~= 0;
    takes_input_name = num_argin < 0 || num_argin >= 2;
    gives_output = num_argout > 0;

    input = {};
    if takes_input_data, input{1} = self.data; end
    if takes_input_name, input{2} = self.function_name; end

    if gives_output
        self.data = function_handle(input{:});
    else
        function_handle(input{:});
    end
end
