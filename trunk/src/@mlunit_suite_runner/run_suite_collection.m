%RECURSIVE_TEST_RUN Execute all test script files of a folder and all its
%subfolders recursively.
%  RECURSIVE_TEST_RUN(BASEDIR) executes all test scripts found in BASEDIR
%  and its sub directories. Reports and log files will go into BASEDIR.
%
%  RECURSIVE_TEST_RUN(BASEDIR, TARGETDIR) does the same, but lets reports
%  and logs be created in the TARGETDIR directory instead of the BASEDIR.
%
%  See also mlunit_gui, mlunit_suite_runner

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = run_suite_collection(self, testobj, targetdir)
   
   if nargin < 1, basedir = pwd; end
   if nargin < 2, targetdir = basedir; end

   % start time for calculating execution time
   start_time = clock;
   
   % buffer current environment state
   previous_environment = mlunit_environment();

   % initialize display
   self = notify_listeners(self, 'initialize_execution', testobj);
   
   % get test suite(s)
   suitespecs = loc_determine_suites(testobj);

   % update display with number of test suites
   count_suites = numel(suitespecs);
   self = notify_listeners(self, 'init_suites', count_suites);

   % Execute each test suite file.
   suiteresults = cell(size(suitespecs));
   for suite=1:count_suites
      [suiteresults{suite}, self] = runTestsuite(self, suitespecs{suite});
      writeXmlTestsuite(suiteresults{suite}, targetdir);
   end

   % restore previous environment state
   mlunit_environment(previous_environment);
   
   % finalize display
   execution_time = etime(clock, start_time);
   self = notify_listeners(self, 'finalize_execution', suiteresults, execution_time);
   

function suitespecs = loc_determine_suites(testobj)

   % Get test files. They may be in basedir or its subdirectories.
   suitespecs = getNestedTestFiles(testobj);


% Run test suite, collect suite and test case attributes and return them.
% suiteresult is a cell array of structures. Each structure contains:
%  name           the package name of the test suite
%  errors         the number of errors
%  failures       the number of failures
%  tests          the number of executed tests
%  time           the time used for executing the tests
%  testcaseList   a list of all testcases with specific information
%     .name       the test case name
%     .classname  the name of the class/package, constructed from the
%                 relative path name and the test suite file name
%     .error      a description of its error. [] if no error.
%     .failure    a description of its failure. [] if no failure.
%     .time       the time used in seconds
function [suiteresult, self] = runTestsuite(self, suitespec)

   self = notify_listeners(self, 'next_suite', suitespec.testname);
   
   % Change to test suite directory. This lets us execute the test suite (function
   % or class) even if shadowed. Pwd will be restored with mlunit_environment.
   cd(suitespec.fulldir);

   [results, time, self] = run_suite(self, strip_classprefix(suitespec.testname));
   suiteresult = build_suiteresult(results, time, suitespec);
   
   
% The results arguments is a struct array with each element representing a test
% case, and with fields:
%   - name    : string, the test case name
%   - errors  : struct array, all errors that occurred during execution, each 
%               a struct in itself with fields message and stack,
%               0x0 struct with these fields, if no errors occurred
%   - failure : string, the failure message, empty, if no failure occurred
%   - time    : double, the execution time in seconds
function suiteresult = build_suiteresult(results, time, suitespec)

   suiteresult = struct();
   suiteresult.time = time;
   suiteresult.name = packageFromRelativeDir(suitespec.reldir, suitespec.testname);
   suiteresult.errors = mlunit_num_suite_errors(results);
   suiteresult.failures = mlunit_num_suite_failures(results);
   suiteresult.tests = numel(results);
   
   % iterate list of test cases in suite
   suiteresult.testcaseList = cell(size(results));
   for t = 1:numel(results)
      testcase = struct();
      testcase.name = results(t).name;
      testcase.classname = suiteresult.name;
      testcase.time = results(t).time;
      msg_and_stack_list = cellfun(@(e) get_message_with_stack(e), results(t).errors, 'UniformOutput', false);
      testcase.error = mlunit_strjoin(msg_and_stack_list, sprintf('\n'));
      testcase.failure = results(t).failure;
      
      % save into list of testcases results
      suiteresult.testcaseList{t} = testcase;
   end
   
   
%% Construct package name from relative dir and testname
function name = packageFromRelativeDir(reldir, testname)

   % start from relative dir name
   name = reldir;
   
   % convert dir separators to dots
   name = strrep(name, '\', '.');
   name = strrep(name, '/', '.');
   
   % chomp leading and dangling dots
   while ~isempty(name) && strncmp('.', name, 1), name(1) = []; end
   while ~isempty(name) && strcmp('.', name(end)), name(end) = []; end
   
   % append testname
   if isempty(name)
      name = testname;
   else
      name = [name '.' testname];
   end
   

function name = strip_classprefix(name)

    if ~isempty(name) && ('@' == name(1))
        name = name(2:end);
    end
