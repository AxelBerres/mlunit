%Load a given suite and execute all its tests.
%  [RESULTS, TIME] = run_suite(SELF, NAME) executes all tests of the suite NAME.
%  NAME is a string denoting a test suite, which must exist on the MATLAB
%  path. SELF is an mlunit_suite_runner instance. If you want to have listeners
%  be notified of test results during suite execution, call add_listeners()
%  before calling run_suite().
%
%  RESULTS is an array of whatever run_test() returned as first argument.
%  TIME is the time needed for suite execution, in seconds.
%
%  After suite execution, the mlUnit environment will be reset to the state it
%  has before suite execution. See mlunit_environment.
%
%  Example
%     % run without listeners; execute in test/utils subdirectory
%     >> [results, time] = run_suite(mlunit_suite_runner, 'test_mlunit_param');
%
%  See also run_test, mlunit_environment

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function [results, time] = run_suite(self, name)

% reload test case file if modified in the same GUI session, e.g. during
% debugging
rehash;

suite_start_time = clock;

% buffer environment for reset after suite execution
previous_environment = mlunit_environment();

% load suite; let errors bubble through, as we have no meaningful way of
% reporting them
if isempty(name)
    % empty name
    error('MLUNIT:emptyTestName', 'Test suite name is empty.');
elseif is_class_test(name)
    % from class
    testsuite = load_tests_from_test_case(test_loader, name);
else
    % from function
    testsuite = eval(name);
end

% TODO: execute suite_set_up

tests = get_tests(testsuite);
num_tests = numel(tests);

% inform progress listeners of impending test updates; keep self updated
for lidx=1:numel(self.listeners)
    self.listeners{lidx} = init_results(self.listeners{lidx}, num_tests);
end

% run each test of the suite; be sure to update the self state with each call
results = cell(size(tests));
for t=1:numel(tests)
    [results{t}, self] = run_test(self, tests{t});
end
% convert back into normal array; we went around by using a cell array, because
% MATLAB is picky when we put them into a plain array directly in the loop
results = [results{:}];

% TODO: execute suite_tear_down

% restore environment after suite execution
mlunit_environment(previous_environment);

time = etime(clock, suite_start_time);
