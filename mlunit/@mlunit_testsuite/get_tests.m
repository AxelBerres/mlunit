%Return the collection of test cases.
%
%  See also TEST_CASE

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function t = get_tests(self, preselection)

if nargin < 2
    t = self.tests;
else
    allnames = cellfun(@get_function_name, self.tests, 'UniformOutput', false);
    indices = ismember(allnames, preselection);
    t = self.tests(indices);
end
