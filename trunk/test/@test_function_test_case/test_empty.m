%Test empty function_test_case instantiation.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = test_empty(self)

% this is an empty function_test_case, having only zero-value handles for test
% function, set_up and tear_down; expected to be runnable
test = function_test_case();
result = run_test(mlunit_suite_runner, test);  %#ok
assert_empty(result.errors);
assert_empty(result.failure);
assert_equals(1, numel(result));
