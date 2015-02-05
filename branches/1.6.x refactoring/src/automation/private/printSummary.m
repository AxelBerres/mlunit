function report = printSummary(suiteresults, time)
% PRINTSUMMARY Return the result of several suites as printable string.
%
% Input argument suiteresults is a cellarray of structures with these fields:
%  name           the package name of the test suite
%  errors         the number of errors
%  failures       the number of failures
%  tests          the number of executed tests
%  time           the time used for executing the tests
%  testcaseList   a list of all testcases with specific information

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author: hetu $
%  $Id: printSummary.m 71 2013-12-14 10:39:02Z hetu $

% helper function for summing up tests, failures, errors
summarize = @(field) sum(cellfun(@(r) r.(field), suiteresults));

num_tests = summarize('tests');
num_fails = summarize('failures');
num_errors = summarize('errors');

separator = sprintf('----------------------------------------------------------------------\n');
lastseparator = sprintf('======================================================================\n');

report = separator;
report = [report sprintf('Executed %s in %.2fs\n', test_count_string(num_tests), time)];
report = [report sprintf('\n')];

% output verdict
if num_fails == 0 && num_errors == 0
    report = [report sprintf('SUCCESS\n')];
end
if num_fails > 0
    report = [report sprintf('%s FAILED\n', test_count_string(num_fails))];
end
if num_errors > 0
    report = [report sprintf('%s had ERRORS\n', test_count_string(num_errors))];
end

% close with separator
report = [report lastseparator];


% outputs '1 test' or '3 tests', depending on num_tests
function s = test_count_string(num_tests)

    s = sprintf('%d test', num_tests);

    % for many or 0 tests, add plural form
    if num_tests ~= 1
        s = [s 's'];
    end
