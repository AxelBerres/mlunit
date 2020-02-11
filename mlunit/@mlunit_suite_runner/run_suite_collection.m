%Execute one or several test suites.
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ) executes all tests of all suites
%  relating to TESTOBJ. If TESTOBJ is a directory, all nested test suites will
%  be collected and executed. If TESTOBJ is a single test suite name, then that
%  only will be executed.
%
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ, TARGETDIR) does the same, but
%  generates jUnit reports into TARGETDIR.
%
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ, TARGETDIR, FAIL) additionally lets
%  the execution fail with a MATLAB error, if FAIL is true. Defaults to false.
%  Normally, this is unnecessary, but helps with automation.
%
%  See also mlunit_gui, mlunit_suite_runner

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = run_suite_collection(self, testobj, targetdir, fail_on_test_fail)

   mlunit_narginchk(2, 4, nargin);
   if isempty(testobj), error('MLUNIT:invalidTestobj', 'Test object must not be empty.'); end
   write_xml = nargin >= 3;
   if nargin < 4, fail_on_test_fail = false; end

   % start time for calculating execution time
   start_time = clock;
   
   % mlock mlunit_param for the duration of the execution
   mlunit_param('-mlock');
   
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
      if write_xml
         writeXmlTestsuite(suiteresults{suite}, targetdir);
      end
   end

   % restore previous environment state
   mlunit_environment(previous_environment);
   
   munlock('mlunit_param');
   
   % finalize display
   execution_time = etime(clock, start_time);
   self = notify_listeners(self, 'finalize_execution', suiteresults, execution_time);

   % fail on test failures, if so requested
   total_problems = sum(cellfun(@(s)s.errors+s.failures,suiteresults));
   if fail_on_test_fail && total_problems > 0
      error('MLUNIT:testFailures', 'Some tests failed or contained errors.');
   end
   

function suitespecs = loc_determine_suites(testobj)

    % neither dir nor file, must be some error
    if ~any(exist(testobj, 'file') == [2,7])
        error('MLUNIT:invalidTestobj', 'Given test object is neither a directory nor a file: ''%s''', testobj);
    end

    % in case of dir, go down recursively
    if exist(testobj, 'dir') == 7
        [dirpath, dirname] = fileparts(testobj);
        if dirname(1) ~= '@'
            % Get test files. They may be in basedir or its subdirectories.
            suitespecs = getNestedTestFiles(testobj);
            return;
        end
        
        % delegate to constructor method
        testobj = fullfile(testobj, dirname(2:end));
    end

    % tokenize path to existing file
    [filepath, filename] = fileparts(which(testobj));
    [parentpath, parentname] = fileparts(filepath);

    % for existing file, construct single spec
    spec = struct();
    spec.reldir = '';
    
    % but handle function and class differently
    isobjectconstructor = ~isempty(parentname) && ...
              parentname(1) == '@' && ...
              isequal(parentname(2:end), filename);
    if isobjectconstructor
        spec.testname = ['@' filename];
        spec.fulldir = parentpath;
    else
        spec.testname = filename;
        spec.fulldir = filepath;
    end
    
    suitespecs = {spec};


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
%     .console    the console output of the test. Empty string if no output.
function [suiteresult, self] = runTestsuite(self, suitespec)

   self = notify_listeners(self, 'next_suite', suitespec.testname);
   
   % Change to test suite directory. This lets us execute the test suite (function
   % or class) even if shadowed. Pwd will be restored with mlunit_environment.
   prevpwd = cd(suitespec.fulldir);

   [results, time, self] = run_suite(self, strip_classprefix(suitespec.testname));
   
   cd(prevpwd);
   
   suiteresult = build_suiteresult(results, time, suitespec);
   
   
% The results arguments is a struct array with each element representing a test
% case, and with fields:
%   - name    : string, the test case name
%   - errors  : struct array, all errors that occurred during execution, each 
%               a struct in itself with fields message and stack,
%               0x0 struct with these fields, if no errors occurred
%   - failure : string, the failure message, empty, if no failure occurred
%   - time    : double, the execution time in seconds
%   - console : string, the console output of the test, empty string if no output
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
      testcase.console = clearFormattingMarkers(results(t).console);
      
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


% Delete strings that MATLAB uses for formatting warnings.
% These are '['+<BACKSPACE> and ']'+<BACKSPACE>.
% These are not allowed as part of HTML CDATA sections.
% Older '{'+<BACKSPACE> markers are allowed in HTML CDATA,
% but show curly brackets for no apparent reason.
function s = clearFormattingMarkers(s)

   backspace = char(8);
   % newer R2018b compatible markers
   s = strrep(s, ['[', backspace], '');
   s = strrep(s, [']', backspace], '');
   % older R2011b compatible markers
   s = strrep(s, ['{', backspace], '');
   s = strrep(s, ['}', backspace], '');
