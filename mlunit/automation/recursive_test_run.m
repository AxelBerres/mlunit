function recursive_test_run(testobj, targetdir, fail_on_test_fail)
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
%  See also mlunit_gui, mlunit_suite_runner

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

if nargin < 1, testobj = pwd; end

suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);

if nargin < 2
    run_suite_collection(suite_runner, testobj);
elseif nargin < 3
    run_suite_collection(suite_runner, testobj, targetdir);
else
    run_suite_collection(suite_runner, testobj, targetdir, fail_on_test_fail);
end
