%Execute one or several test suites.
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ) executes all tests of all suites
%  relating to TESTOBJ. If TESTOBJ is a directory, all nested test suites will
%  be collected and executed. If TESTOBJ is a single test suite name, then that
%  only will be executed. If TESTOBJ is a test suite object already, then that
%  only will be executed. If TESTOBJ is a cell array of 'testsuite.testname' strings,
%  only these tests across their containing suites will be executed.
%
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ, TARGETDIR) does the same, but
%  generates jUnit reports into TARGETDIR.
%
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ, TARGETDIR, FAIL) additionally lets
%  the execution fail with a MATLAB error, if FAIL is true. Defaults to false.
%  Normally, this is unnecessary, but helps with automation.
%
%  SELF = RUN_SUITE_COLLECTION(SELF, TESTOBJ, TARGETDIR, FAIL, INCLUDEMATLABTESTS)
%  additionally includes MATLAB unit tests if set to true. Defaults to true.
%
%  See also mlunit_gui, mlunit_suite_runner

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = run_suite_collection(self, testobj, targetdir, fail_on_test_fail, include_matlab_tests)

   mlunit_narginchk(2, 5, nargin);
   if isempty(testobj), error('MLUNIT:invalidTestobj', 'Test object must not be empty.'); end
   if nargin < 3 || isempty(targetdir), targetdir = ''; end
   write_xml = ~isempty(targetdir);
   if nargin < 4 || isempty(fail_on_test_fail), fail_on_test_fail = false; end
   if nargin < 5 || isempty(include_matlab_tests), include_matlab_tests = true; end
   if verLessThan('matlab', '9.7.0')
       if include_matlab_tests
           warning('MLUNIT:noMatlabUnitTests', 'mlUnit supports running MATLAB unit tests only from MATLAB R2019b onwards. Here, MATLAB unit tests will be ignored.');
       end
       include_matlab_tests = false;
   end

   % start time for calculating execution time
   start_time = clock;
   
   % mlock mlunit_param for the duration of the execution
   mlunit_param('-mlock');
   
   % buffer current environment state
   previous_environment = mlunit_environment();

   % initialize display
   self = notify_listeners(self, 'initialize_execution', loc_get_testobj_string(testobj));
   
   % get test suite(s)
   suitespecs = loc_determine_suites(testobj, include_matlab_tests);

   % update display with number of test suites
   count_suites = numel(suitespecs);
   self = notify_listeners(self, 'init_suites', count_suites);

   % Execute each test suite file.
   suiteresults = cell(size(suitespecs));
   for suite=1:count_suites
      [suiteresults{suite}, self] = runTestsuite(self, suitespecs{suite}, targetdir);
      if write_xml && ~isfield(suiteresults{suite}, 'jUnitAlreadyCreated')
         writeXmlTestsuite(suiteresults{suite}, targetdir);
      end
   end

   % restore previous environment state
   mlunit_environment(previous_environment);
   
   munlock('mlunit_param');
   
   % finalize display
   execution_time = etime(clock, start_time);
   self = notify_listeners(self, 'finalize_execution', suiteresults, execution_time);

   % save run information for subsequent reruns
   mlunit_rerun('save', struct('suiteresults', {suiteresults}, 'testobj', {loc_get_testobj_string(testobj)}));
   
   % fail on test failures, if so requested
   total_problems = sum(cellfun(@(s)s.errors+s.failures,suiteresults));
   if fail_on_test_fail && total_problems > 0
      error('MLUNIT:testFailures', 'Some tests failed or contained errors.');
   end
   
function suitespecs = loc_determine_suites(testobj, include_matlab_tests)

    % in case of object, prep up some custom suitespec
    if isa(testobj, 'mlunit_testsuite')
        spec = struct();
        spec.reldir = '';
        spec.testname = get_name(testobj);
        spec.fulldir = fileparts(which(spec.testname));
        spec.object = testobj;
        spec.testselection = {};
        suitespecs = {spec};
        return
    end
    
    if isstruct(testobj) && ~isempty(testobj) && isfield(testobj, 'suitespecs')
        suitespecs = testobj.suitespecs;
        return
    end

    selected_test = '';
    if iscellstr(testobj) && numel(testobj) == 1
        [testobj, rest] = strtok(testobj{1}, '.');
        selected_test = strtok(rest, '.');
    end
    
    isFileTestObj = exist(testobj, 'file') == 2;
    isDirTestObj = exist(testobj, 'dir') == 7;

    % neither dir nor file, must be some error
    if ~isFileTestObj && ~isDirTestObj
        error('MLUNIT:invalidTestobj', 'Given test object is neither a directory nor a file: ''%s''', testobj);
    end

    % dir as well as file, prefer file and tell user
    if isFileTestObj && isDirTestObj
        warning('MLUNIT:testNameDirCollision', 'The test object ''%s'' exists as a file and as a directory. Please rename either one.\nRight now, only the file will be executed.', testobj);
    end

    % in case of dir, go down recursively
    if ~isFileTestObj && isDirTestObj
        [dirpath, dirname] = fileparts(testobj);
        if dirname(1) ~= '@'
            % Get test files. They may be in basedir or its subdirectories.
            suitespecs = getNestedTestFiles(testobj, include_matlab_tests);
            return
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
    
    spec.object = [];
    spec.testselection = {};
    if ~isempty(selected_test)
       spec.testselection = {selected_test};
    end
    suitespecs = {spec};

    
function testobjstring = loc_get_testobj_string(testobj)

    if isa(testobj, 'mlunit_testsuite')
        testobjstring = get_name(testobj);
    elseif isstruct(testobj) && ~isempty(testobj) && isfield(testobj, 'testobj')
        testobjstring = testobj.testobj;
    elseif iscellstr(testobj) && numel(testobj) == 1
        testobjstring = testobj{1};
    else
        testobjstring = testobj;
    end
    

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
%     .skip       a description of why the test was skipped. [] if no skip.
%     .time       the time used in seconds
%     .console    the console output of the test. Empty string if no output.
function [suiteresult, self] = runTestsuite(self, suitespec, targetdir)

   self = notify_listeners(self, 'next_suite', suitespec.testname);
   
   % handle MATLAB unit tests separately
   if isfield(suitespec, 'matlabtests') && ~isempty(suitespec.matlabtests)
       [suiteresult, self] = runMatlabTestsuite(self, suitespec, targetdir);
       return
   end

   % Change to test suite directory. This lets us execute the test suite (function
   % or class) even if shadowed. Pwd will be restored with mlunit_environment.
   prevpwd = cd(suitespec.fulldir);

   if ~isempty(suitespec.object)
       target = suitespec.object;
   else
       target = strip_classprefix(suitespec.testname);
   end
   
   if ~isempty(suitespec.testselection)
       [results, time, self] = run_suite(self, target, suitespec.testselection);
   else
       [results, time, self] = run_suite(self, target);
   end
   
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
   suiteresult.suitespec = suitespec;
   suiteresult.errors = mlunit_num_suite_errors(results);
   suiteresult.failures = mlunit_num_suite_failures(results);
   suiteresult.skipped = mlunit_num_suite_skipped(results);
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
      testcase.skipped = results(t).skipped;
      testcase.console = clearFormattingMarkers(results(t).console);
      
      % save into list of testcases results
      suiteresult.testcaseList{t} = testcase;
   end

function suiteresult = build_suiteresult_matlab(results, suitespec)

   suiteresult = struct();
   suiteresult.time = sum([results.time]);
   suiteresult.name = suitespec.testname;
   suiteresult.suitespec = suitespec; % rerun not supported for MATLAB unit tests
   suiteresult.errors = mlunit_num_suite_errors(results);
   suiteresult.failures = mlunit_num_suite_failures(results);
   suiteresult.skipped = mlunit_num_suite_skipped(results);
   suiteresult.tests = numel(results);
   suiteresult.jUnitAlreadyCreated = true;
   
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
      testcase.skipped = results(t).skipped;
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


function [suiteresult, self] = runMatlabTestsuite(self, suitespec, targetdir)

    write_xml = nargin >= 3 && ~isempty(targetdir);

    self = notify_listeners(self, 'init_results', numel(suitespec.matlabtests));

    if verLessThan('matlab', '9.10') % testrunner introduced with R2021a
        runner = matlab.unittest.TestRunner.withNoPlugins;
    else
        runner = testrunner('minimal');
    end

    if write_xml
        filename = fullfile(targetdir, ['TEST-', suitespec.testname, '.xml']);
        addPlugin(runner, matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(filename));
    end

    if verLessThan('matlab', '23.2')
        runFcn = @run; %#ok<NASGU> 
        arrayfun(@(plugin)runner.addPlugin(plugin), suitespec.matlabparser_results.Plugins);
        [output, matlab_results] = evalc('runFcn(runner, suitespec.matlabtests)');
    elseif verLessThan('matlab', '24.2') %#ok<VERLESSMATLAB> compatibility
        runFcn = matlab.unittest.internal.getRunFcn(suitespec.matlabparser_results.Options, suitespec.matlabparser_results.Plugins, suitespec.matlabtests, runner.ArtifactsRootFolder); %#ok<NASGU> evalc
        arrayfun(@(plugin)runner.addPlugin(plugin), suitespec.matlabparser_results.Plugins);
        [output, matlab_results] = evalc('runFcn(runner, suitespec.matlabtests)');
    else
        testOutputHandler = suitespec.matlabparser_results.Options.TestViewHandler_; %#ok<NASGU>
        [output, matlab_results] = evalc('testOutputHandler.runTests(suitespec.matlabparser_results.Options, suitespec.matlabparser_results.Plugins, suitespec.matlabtests, runner)');
    end

    results = cell(size(matlab_results));
    for t = 1:numel(matlab_results)
        result = struct();
        result.name = get_matlab_testname(matlab_results(t).Name);
        result.time = matlab_results(t).Duration;
        result.console = output;
        result.variations = [];

        if matlab_results(t).Failed && matlab_results(t).Incomplete
            result.errors = {mlunit_errorinfo(struct('message', {matlab_results(t).Details.DiagnosticRecord.Report}))};
        else
            result.errors = {};
        end

        if matlab_results(t).Failed && ~matlab_results(t).Incomplete
            result.failure = matlab_results(t).Details.DiagnosticRecord.Report;
        else
            result.failure = '';
        end

        if ~matlab_results(t).Failed && matlab_results(t).Incomplete
            result.skipped = matlab_results(t).Details.DiagnosticRecord.Report;
        else
            result.skipped = '';
        end

        % pretend this was just executed
        self = notify_listeners(self, 'next_result', result);

        % save into list of testcases results
        results{t} = result;
    end

    % convert to array, expected by build_suiteresult_matlab
    results = [results{:}];
    suiteresult = build_suiteresult_matlab(results, suitespec);


function name = get_matlab_testname(suite_name)

    parts = mlunit_strsplit(suite_name, '/');
    name = parts{2};
