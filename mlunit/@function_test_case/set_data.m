function self = set_data(self, data)
%function_test_case/set_data overwrite function test data.
%
%  Used for initializing test and suite_tear_down test data.
%  Test data means whatever function tests interchange between set_up, test, and
%  tear_down.
%
%  See also FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

self.data = data;
