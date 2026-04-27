%Finalize mlUnit execution
%  SELF = FINALIZE_EXECUTION(SELF, RESULTS, EXECUTION_TIME) tells the listener
%  to wrap up the final results of the execution.
%  RESULTS is a cell array of structures. Each structure contains:
%      name           the package name of the test suite
%      errors         the number of errors
%      failures       the number of failures
%      tests          the number of executed tests
%      time           the time used for executing the tests
%      testcaseList   struct array of all testcases with specific information
%         .name       the test case name
%         .classname  the name of the class/package, constructed from the
%                     relative path name and the test suite file name
%         .error      a description of its error. [] if no error.
%         .failure    a description of its failure. [] if no failure.
%         .skip       a description of why the test was skipped. [] if no skip.
%         .time       the time used in seconds
%         .console    the console output of the test. Empty string if no output.
%
%  This method is provided by the user, but should not be called by her.
%
%  See also initialize_execution

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = finalize_execution(self, results, execution_time)

set(self.text_time, 'String', sprintf('Finished: %.3fs.\n', execution_time));

% Return early if there is normal test output.
items = get(self.error_listbox, 'String');
if ~isempty(items)
    return;
end

% Show some special text if there's nothing else to show.
actualResults = any(cellfun(@(r)r.tests > 0, results));
if actualResults
    specialtext = sprintf('%s\n%s\n\n%s', ...
        'All tests pass!', ...
        'If there''s nothing else to do, enjoy this:', ...
        random_quip());
else
    specialtext = 'No tests were run.';
end

handles = guidata(self.error_listbox);
set(handles.gui_error, 'String', specialtext);
