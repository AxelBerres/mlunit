function data = get_data(self)
%function_test_case/get_data return function test data.
%
%  Used for obtaining suite_set_up test data.
%  Test data means whatever function tests interchange between set_up, test, and
%  tear_down.
%
%  See also FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

data = self.data;
