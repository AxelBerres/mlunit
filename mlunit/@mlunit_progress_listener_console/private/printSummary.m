function report = printSummary(suiteresults, time)
% PRINTSUMMARY Return the result of several suites as printable string.
%
% Input argument suiteresults is a cellarray of structures with these fields:
%  name           the package name of the test suite
%  errors         the number of errors
%  failures       the number of failures
%  tests          the number of executed tests
%  time           the time used for executing the tests
%  console        the console output of the suite_set_up and suite_tear_down fixtures
%  testcaseList   a list of all testcases with specific information

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: printSummary.m 71 2013-12-14 10:39:02Z hetu $

% helper function for summing up tests, failures, errors
summarize = @(field) sum(cellfun(@(r) r.(field), suiteresults));

num_suites = numel(suiteresults);
num_tests = summarize('tests');
num_fails = summarize('failures');
num_errors = summarize('errors');

separator = sprintf('----------------------------------------------------------------------\n');
lastseparator = sprintf('======================================================================\n');

report = separator;
report = [report sprintf('Executed %s across %s in %.2fs\n', ...
    test_count_string(num_tests), ...
    plural_form('suite', num_suites), ...
    time)];
report = [report sprintf('\n')];

% output verdict
if num_fails == 0 && num_errors == 0
    report = [report sprintf('SUCCESS\n')];
else
    % In case of any problems, print both failure and error count, even if
    % one of them is 0. But having both informations boosts confidence.
    report = [report sprintf('%s FAILED\n', test_count_string(num_fails))];
    report = [report sprintf('%s had ERRORS\n', test_count_string(num_errors))];
end

% close with separator
report = [report lastseparator];


% outputs '1 test' or '3 tests', depending on num_tests
function s = test_count_string(num_tests)

    s = plural_form('test', num_tests);


% outputs '1 test' or '3 tests', depending on num_tests
function s = plural_form(verb, num_elements)

    s = sprintf('%d %s', num_elements, verb);

    % for many or 0 items, add plural form
    if num_elements ~= 1
        s = [s 's'];
    end
