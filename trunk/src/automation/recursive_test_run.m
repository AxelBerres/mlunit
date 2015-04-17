function recursive_test_run(basedir, targetdir)
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
 
if nargin < 1, basedir = pwd; end
if nargin < 2, targetdir = basedir; end

suite_runner = mlunit_suite_runner;
suite_runner = add_listener(suite_runner, mlunit_progress_listener_console);
run_suite_collection(suite_runner, basedir, targetdir);
