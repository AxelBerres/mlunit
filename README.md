=================
   m l U n i t
=================

mlUnit is a unit test framework for the MATLAB M language.
It follows patterns of the xUnit family, including assertions,
test cases and suites as well as the fixture.

In contrast to MATLAB's own unit test framework:

* mlUnit outputs jUnit compatible XML reports
* mlUnit is compatible with Your MATLAB (not just R2013b), down to R2006b
* mlUnit offers specialised assert functions, e.g. assert_empty, assert_warning,
  and many more.

This software and all associated files are released unter the GNU General 
Public License (GPL) as published by the Free Software Foundation (see 
LICENSE file).

===========================================================================


PREPARATION


mlUnit may be installed (paths registered in MATLAB), or employed dynamically
on a per-use base.


INSTALLATION

1. Unzip mlunit.zip to $HOME.
2. Change to directory in MATLAB:

   >> cd $HOME/mlunit/mlunit

3. Add directory to MATLAB path:

   >> addpath('$HOME/mlunit/mlunit');

4. Save the MATLAB path.


DYNAMICAL EMPLOYMENT

1. Add all source file directories to the MATLAB search path.
2. Add mlUnit to the MATLAB search path, including sub directories.
   Alternatively, call the setpath.m script in this directory.
3. Add test file directories to the MATLAB search path. Necessary for test
   scripts that call test function from other directories. Not needed else.
   mlUnit will change the working directory for each test script to its
   directory. That way, test scripts may use relative paths to refer to data in
   sub directories, e.g. images.


REQUIREMENTS

mlUnit is expected to run on all MATLAB versions from R2006b up to any new
version. It has been tested with R2006b, R2007b, R2011b, R2014b and R2015b.

===========================================================================


USAGE


Execute mlUnit manually or automatically from within MATLAB, or
fully automatized from your Ant automation script or the Windows console.


Manual Execution
----------------

Execute run(mlunit). Provide the name of a test script file in the
dialog and apply.


Automatic Execution
-------------------

Execute recursive_test_run. Provide one input argument: The full path to the
test directory. Provide an optional second input argument: The full path to the
target directory receiving the jUnit XML reports.


Ant automation
--------------

You may skip all of the above steps, even preparation, and execute
your unit tests with an Apache Ant script, or on the Windows console.

In your own Ant script, define a property named matlab.root that defines the
directory of the MATLAB installation you want to invoke.
Make a call like <ant antfile="mlunit/build.xml"/> to execute all unit
tests and receive the jUnit XML reports. Read build.xml's description for
further instructions.

On the console, make sure to have Ant on your path. Then call Ant with the
matlab.root property set to your MATLAB executable. E.g.:

    ant -Dmatlab.root="C:\Program Files\MATLAB\R2007b"

Or even try the MATLAB that's found on your system path:

    ant

R2014b gives no output when being executed via Ant. This seems to be a
change in R2014b. The core MATLAB.EXE no longer outputs on stdout if
being called with the -automation option. But mlUnit's current
matlabcommand.xml should recognize failures, even without stdout output,
as it works on the log file produced.


===========================================================================


HOW TO TEST


As an example a test for the built-in sin function is written:

1. Create a new directory @test_sin: 

   >> mkdir @test_sin
   >> cd @test_sin

2. Create a new .m file test_sin.m (the constructor):

   >> edit test_sin.m

3. Add the following lines to test_sin.m:

   function self = test_sin(name)

   tc = test_case(name);
   self = class(struct([]), 'test_sin', tc);

4. Create a new file test_null.m (the first test) and add the following 
   lines:

   function self = test_null(self)

   assert_equals(0, sin(0));

5. Run the test:

   >> cd('sample');
   >> run(mlunit);

   Enter 'test_sin' and press 'Run'.
   You should see a green bar and the text:

   Runs: 1 / Errors: 0 / Failures: 0

6. Add more tests, e.g. test_sin_cos.m:

   function self = test_sin_cos(self)

   assert_equals(cos(0), sin(pi/2));

7. Rerun the tests:

   Press 'Run' again. You should see the text:

   Runs: 2 / Errors: 0 / Failures: 0


Note: The numbers for errors and failures are usually smaller or equal to the
number of tests being run, even when summed up, e.g. errors+failures <= runs.
However, sometimes they may exceed the number of tests being run. This is in
fact expected and valid behavior. Consider a test suite containing a single
test case. Let the test case implementation fail an assertion. The test's
tear_down function will be called after the assertion failure. If that tear_down
raises an error in itself, then that test case accounts for one failure and one
error, both which will be reported. In your worst case, you may end up with as
many failures as tests being run, and also with as many errors.

When naming test suite files, consider following restrictions. The name of any
test suite file must not exceed 63 characters, or rather what your MATLAB
returns for namelengthmax. Your operating system may impose other restrictions.
When on Windows, the full, absolute path to any test suite file (including name
and extension) must not exceed 260 characters. Otherwise, MATLAB cannot evaluate
the test suite file. This restriction also holds for generated reports.
Be careful when using a custom report base directory that is longer than the
directory containing your test cases. Otherwise, MATLAB may not be able
to write the jUnit reports.

===========================================================================


PARAMETERS AND BRIDGING FIXTURES


You can define parameters in order to change mlUnit's behaviour. For example,
in order to let assert_equals handle NaN values as equal, call:

    >> mlunit_param('equal_nans', true);

You should do this in a test suite's set_up fixture. As of mlUnit 1.6.8, this
won't affect other suite's tests anymore, i.e. declare equal NaNs for just one
suite, but not the others. Changes to mlUnit parameters, that are effected in
either the test function, or the set_up and tear_down fixtures, will be reverted
after each test's tear_down execution. The same applies to changes to the MATLAB
path or the working directory.

The parameters are protected against calls to MATLAB's clear (with the
'functions', 'all', or 'java' arguments), or calls to javaaddpath or javarmpath,
which trigger calls to clear. These calls reset persistent variables, among
doing other things. But mlunit_param's persistent variables are protected by
mlock. The protection is in place for the duration of any mlUnit execution
(actually running tests, not just having the GUI open).
However, those commands also have other side effects, specifically resetting
debug breakpoints. If you frequently find yourself breakpoint-debugging test
code that contains javaaddpath or clear calls, consider wrapping them like this:

    dbgstate = dbstatus;   % temporarily save your breakpoints
    javaaddpath(mypath);   % the problematic call, resets breakpoints
    dbstop(dbgstate);      % restore your breakpoints

mlUnit does not reset the javaclasspath as it resets the MATLAB path, the
working directory, and the mlUnit parameters. That is exactly because changing
the javaclasspath induces a reset of all persistent variables across the
MATLAB session, and maybe also a reset of current Java instances.
It would be a dubious thing to do by default. Therefore, handling the
javaclasspath is left up to the user.


Description of parameters
-------------------------

equal_nans -- Normally, MATLAB judges two NaN values incomparable. That is,
a call like isequal(NaN, NaN) yields false. This also holds in mlUnit when using
assert_equals and assert_not_equals.
However, when you need NaNs to be considered equal, set equal_nans to true.

linked_trace -- When being executed on the MATLAB console, stack trace items are
displayed as links, so you can jump to the relevant code with one click.
However, this does not work in mlUnit's GUI. A MATLAB GUI edit box can not
display HTML links as the console does. There is a hack to enable all-HTML
rendering, but that requires an inappropriately enormous overhead.
When being executed automatically, i.e. when the stack trace is meant for
logging, linked_trace should be set to false in order for the HTML tags to
not show up.

abbrev_trace -- Stack item names are shortened by default, making them much
easier to read for their most common application -- locating a failure's origin.
However, this hides errors where one file shadows another of the same name, and
is used instead. If you encounter strange behaviour that should not occur in a
specific implementation, set abbrev_trace to false in order to see absolute file
paths.

verbose -- By default, mlUnit reports only test cases that failed or had errors.
When using recursive_test_run, mlUnit also reports which test suites actually
executed.
However, sometimes you may need to also know which test cases succeeded, or
in which order the test cases executed, or to what test case some interposing
debug output belongs. In these cases, set verbose to true.

For details of how to employ these parameters, see:

   >> help mlunit_param


Bridging fixtures
-----------------

You can use these parameters for your own purposes, too. Just be careful
not to employ names known to mlUnit. Check the list of known parameters with:

   >> help mlunit_param

That being said, you can use parameters for your own purposes,
e.g. to bridge information between fixture calls.
For example, if you calculate some path name in your set_up fixture,
and want to access it in your tear_down fixture, store it as an mlUnit
parameter. Although file and directory dependencies are generally discouraged
in unit tests and should be avoided where possible, let this serve as example:

   function set_up
      % open file for reading
      fid = fopen('my/path/myfile.txt');
      % remember file id
      mlunit_param('my_precious_fid', fid);

   function tear_down
      % recall file id and close it
      fid = mlunit_param('my_precious_fid');
      fclose(fid);

===========================================================================


MLUNIT TESTS


As mlUnit was developed loosely test-driven, there are a number of tests in the
test directory, which can be run by

>> recursive_test_run('$MLUNIT\mlunit\test')

===========================================================================


MIGRATION

With 1.6.10, function test suites should change their front loading mechanism,
if they are going to be run under MATLAB R2015b or newer. Proper function suites
should now look something like:

    function test = test_myimplementation
        output_tests_from_mfile;
    ...

The function's return parameter must be called "test" and the
"output_tests_from_mfile" script must be invoked in this way, instead of the
now deprecated load_tests_from_mfile. However, load_tests_from_mfile is retained
for compatibility with old projects on pre R2015b releases.

With 1.6.8, there are several usage changes. In lack of a current write-up,
please consult the CHANGES.txt for the 1.6.8 release.

With 1.6.4, assert() is no mlUnit function anymore. Replace your assert()
calls with calls to assert_true() in test cases. In places where you actually
want to assert a constraint in production code rather than a test case, use the
MATLAB built-ins assert() or error().

===========================================================================


QUESTIONS, COMMENTS, BUGS

If you have a question, a comment or a bug report, please send an email to 
any of the maintainers.
