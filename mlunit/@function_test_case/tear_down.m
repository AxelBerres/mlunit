function self = tear_down(self)
%test_case/tear_down called calls the tear_down_function by the function 
%handle everytime after a test is executed for cleaning up the fixture.
%
%  Example
%  =======
%  tear_down is not called directly, but through the method run. Example:
%         test = ... % e.g. created through load_tests_from_mfile
%         [test, result] = run(test); 
%         summary(result)
%
%  See also TEST_CASE, FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

self = call_with_data(self, self.tear_down_function);
