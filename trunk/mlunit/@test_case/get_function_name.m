%Return the function name of this function-based test case instance.
%  This is the current test case subfunction's name for function-based
%  test suites.
%
%  See also test_case

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function n = get_function_name(self)

n = self.function_name;
