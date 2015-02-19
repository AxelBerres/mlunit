%Load a given suite and execute all its tests.
%
%  Example
%  =======
%  There are two ways of calling run:
%
%  1) [test, result] = run(test) uses the default test result.
%
%  2) [test, result] = run(test, result) uses the result given as
%     paramater, which allows to collect the result of a number of tests
%     within one test result.
%
%  See also TEST_CASE.

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
if is_class_test(name)
    % from class
    testsuite = load_tests_from_test_case(test_loader, name);
else
    % from function
    testsuite = eval(name);
end

% TODO: execute suite_set_up

tests = get_tests(testsuite);
num_tests = numel(tests);

% inform progress listeners of impending test updates
cellfun(@(l) init_results(l, num_tests), self.listeners);

% run each test of the suite
results = cellfun(@(t) run_test(self, t), tests);

% TODO: execute suite_tear_down

% restore environment after suite execution
mlunit_environment(previous_environment);

time = etime(clock, suite_start_time);
