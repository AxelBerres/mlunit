function recursive_test_run(basedir, targetdir)
%RECURSIVE_TEST_RUN Execute all test script files of a folder and all its
%subfolders recursively.
%  RECURSIVE_TEST_RUN(BASEDIR) executes all test scripts found in BASEDIR
%  and its sub directories. Reports and log files will go into BASEDIR.
%
%  RECURSIVE_TEST_RUN(BASEDIR, TARGETDIR) does the same, but lets reports
%  and logs be created in the TARGETDIR directory instead of the BASEDIR.
%
%  See also GUI_TEST_RUNNER, TEXT_TEST_RUNNER

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$
   
   if nargin < 1, basedir = pwd; end
   if nargin < 2, targetdir = basedir; end

   % start time for calculating execution time
   start_time = clock;
   
   % print header
   disp(printHeader(basedir));
   
   % Get test files. They may be in basedir or its subdirectories.
   suitespecs = getNestedTestFiles(basedir);
   
   % Remember previous working directory
   prevpwd = pwd;
   
   % Execute each test suite file.
   count_suites = numel(suitespecs);
   suiteresults = cell(size(suitespecs));
   for suite=1:count_suites
      % Change to test case directory. Test cases may expect their own
      % directory to be the working directory.
      cd(suitespecs{suite}.fulldir);
      
      suiteresult = runTestsuite(suitespecs{suite});
      suiteresults{suite} = suiteresult;
      
      disp(printTestsuite(suiteresult));
      writeXmlTestsuite(suiteresult, targetdir);
   end

   % print summary
   execution_time = etime(clock, start_time);
   disp(printSummary(suiteresults, execution_time));
   
   % Restore previous working directory
   cd(prevpwd);


%% Run test suite, collect suite and test case attributes and return them.
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
%     (.time)     the time used. Not supported.
function suiteresult = runTestsuite(suitespec)

   suiteresult = struct();
   
   if isclassdir(suitespec.testname)
       testsuite_obj = load_tests_from_test_case(test_loader, clean_classname(suitespec.testname));
   else
       % get the mlUnit object for the test case
       testsuite_obj = eval(suitespec.testname);
   end
   
   % run test suite with time measure
   result_obj = test_result;
   tic
   [testsuite_obj, result_obj] = run(testsuite_obj, result_obj);
   suiteresult.time = toc;
   
   % obtain other test suite attributes
   suiteresult.name = packageFromRelativeDir(suitespec.reldir, suitespec.testname);
   suiteresult.errors = get_errors(result_obj);
   suiteresult.failures = get_failures(result_obj);
   suiteresult.tests = get_tests_run(result_obj);
   
   errorList = get_error_list(result_obj);
   failureList = get_failure_list(result_obj);
   
   % iterate list of test cases in suite
   suiteresult.testcaseList = [];
   testcase_list = tests(testsuite_obj);
   for t = 1:length(testcase_list)
      % get testcase object
      testcase_obj = testcase_list{t};

      % no way to get the per-testcase time out of mlUnit
      % testcase.time = ;
      
      % fill in names
      testcase.classname = suiteresult.name;
      testcase.name = get_function_name(testcase_obj);
      
      % get any errors
      testcase.error = findError(testcase_obj, errorList);
      testcase.failure = findError(testcase_obj, failureList);
      
      % save into list of testcases results
      suiteresult.testcaseList{t} = testcase;
   end
   
   
%% Return error message of first occurrence of testcase_obj in list
function message = findError(testcase_obj, list)

   % Empty message means no error found.
   message = [];
   listelements = size(list, 1);
   for i = 1:listelements
      testcase = list{i, 1};
      if isequal(testcase, testcase_obj)
         % We found a marked error.
         message = list{i, 2};
         % If the actual message is empty, fill in something. If we return
         % an empty message, others may think no errors found.
         if isempty(message)
            message = 'No message.';
         end
         break;
      end
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
   

function report = printHeader(basedir)

    % start with gap to any previous output
    report = sprintf('\n');
    report = [report sprintf('----------------------------------------------------------------------\n')];
    report = [report sprintf('mlUnit %s\n', ver(mlunit, true))];
    report = [report sprintf('Started: %s.\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'))];
    report = [report sprintf('Test directory: %s\n', basedir)];
    report = [report sprintf('----------------------------------------------------------------------\n')];


function bIsClass = isclassdir(name)

    bIsClass = ~isempty(name) && strcmp(name(1), '@');

function name = clean_classname(name)

    if ~isempty(name)
        name = name(2:end);
    end