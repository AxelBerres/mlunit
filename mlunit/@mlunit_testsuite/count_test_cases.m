function count = count_test_cases(self)
%test_suite/count_test_cases returns the number of test cases executed 
%by run.
%
%  See also TEST_SUITE, TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: count_test_cases.m 36 2006-06-11 16:45:23Z thomi $

count = numel(self.tests);
