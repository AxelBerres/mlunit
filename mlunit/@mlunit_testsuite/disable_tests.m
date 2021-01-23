% Disable some or all test cases of a test suite.
%
% Disable tests in order to ignore known problems, or if prerequisites don't hold.
% Disabled tests will be skipped and show up as SKIPPED in the test run.
% In contrast to calling mlunit_skip in the test itself, disabling a test will not execute
% set_up and tear_down for that test.
%
% Call disable_tests on the mlunit_testsuite object returned by the load_tests_from_mfile
% call in the test header. For example, disable test_case1 of test_mysuite:
%
%     function test_mysuite
%       test = load_tests_from_mfile(test_loader);
%       test = disable_tests(test, 'test_case1', 'KnownIssue #5773');
%     end
%
% test = disable_tests(test, TC, MSG) disables the single test case TC. If TC is a cellstr
% array, all contained test case names are disabled. MSG is a char array denoting the
% reason for disabling these tests.
%
% test = disable_tests(test, 'all', MSG) disables all test cases of the test suite. MSG
% gives a reason.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = disable_tests(self, excludeNames, reasonMessage)

excludes = {};
reason = '';
excludeAll = false;

if nargin >= 2
    if ischar(excludeNames) && strcmpi('all', excludeNames)
        excludeAll = true;
    elseif ~iscellstr(excludeNames)
        error('MLUNIT:inputCellstr', 'When giving 2 arguments, the second argument, EXCLUDES must be a cellstr array, or ''all''.');
    else
        excludes = excludeNames;
    end
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
   
   if excludeAll || any(strcmp(testName, excludes))
      self.tests{tidx} = set_disabled(self.tests{tidx}, reason);
   end
end
