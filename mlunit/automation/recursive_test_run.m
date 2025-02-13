function recursive_test_run(testobj, varargin)
%RECURSIVE_TEST_RUN Execute all test script files of a folder and all its
%subfolders recursively.
%  RECURSIVE_TEST_RUN(BASEDIR) executes all test scripts found in BASEDIR
%  and its sub directories. Reports and log files will go into BASEDIR.
%  BASEDIR may be a relative or an absolute path.
%
%  RECURSIVE_TEST_RUN(SUITE) executes just one test suite SUITE.
%
%  RECURSIVE_TEST_RUN(TESTOBJ, TARGETDIR) does the same, but lets reports
%  and logs be created in the TARGETDIR directory.
%
%  RECURSIVE_TEST_RUN(TESTOBJ, TARGETDIR, FAIL) additionally lets
%  the execution fail with a MATLAB error, if FAIL is true. Defaults to false.
%  Normally, this is unnecessary, but helps with automation.
%
%  RECURSIVE_TEST_RUN(TESTOBJ, TARGETDIR, FAIL, INCLUDEMATLABTESTS)
%  additionally includes MATLAB unit tests if set to true. Defaults to true.
%
%  See also mlunit_gui, mlunit_suite_runner

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin < 1 || isempty(testobj), testobj = pwd; end

suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
run_suite_collection(suite_runner, testobj, varargin{:});
