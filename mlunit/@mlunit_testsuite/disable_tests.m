%Return the collection of test cases.
%
%  See also TEST_CASE

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = disable_tests(self, excludeNames, reasonMessage)

excludes = {};
reason = '';

if nargin >= 2
    if ~iscellstr(excludeNames)
        error('MLUNIT:inputCellstr', 'When giving 2 arguments, the second argument, EXCLUDES must be a cellstr array.');
    end
    excludes = excludeNames;
end

if nargin >= 3
    if ~ischar(reasonMessage)
        error('MLUNIT:inputCellstr', 'When giving 3 arguments, the third argument, REASON must be a char array.');
    end
    reason = reasonMessage;
end

for tidx = 1:numel(self.tests)
   
   % get test case name
   if isa(self.tests{tidx}, 'function_test_case')
      testName = get_function_name(self.tests{tidx});
   elseif isa(self.tests{tidx}, 'test_case')
      testName = get_name(self.tests{tidx});
   else
      continue
   end
   
   if any(strcmp(testName, excludes))
      self.tests{tidx} = set_disabled(self.tests{tidx}, reason);
   end
end
