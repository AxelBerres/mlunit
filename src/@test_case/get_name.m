%Return the method name of this test case instance.
%  This is the current test case method's name for class test cases.
%  This is 'run_test' for function test cases.
%
%  See also test_case

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function n = get_name(self)

n = self.name;
