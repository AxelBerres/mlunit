function test = test_isclass %#ok<STOUT>

output_tests_from_mfile;

function test_noargs %#ok<DEFNU>
    
    assert_error(@() isclass());

function test_char %#ok<DEFNU>

    assert_false(isclass(''));
    
function test_numeric %#ok<DEFNU>

    assert_false(isclass(42));

function test_handle %#ok<DEFNU>

    assert_true(ishandle(0));
    assert_false(isclass(0));

function test_functionhandle %#ok<DEFNU>

    fh = @(x) x*x+x;
    assert_true(isa(fh, 'function_handle'));
    assert_false(isclass(fh));

function test_javaobject %#ok<DEFNU>

    jo = java.lang.String('hiho');
    assert_true(isjava(jo));
    assert_false(isclass(jo));

function test_object %#ok<DEFNU>

    assert_true(isclass(timeseries(1:12)));

% Test on a Simulink.ModelWorkspace object, which seems to be a special
% type of object. Needs Simulink installed.
function test_object_SimulinkModelWorkspace %#ok<DEFNU>

    % Load a model, query its ModelWorkspace parameter and leave it open.
    syshandle = new_system();
    mdlWorkspace = get_param(syshandle, 'ModelWorkspace');

    % We need to examine the Simulink.ModelWorkspace in a hot state, i.e. with
    % the model still loaded. Close it only afterwards, but in any case.
    close_system_hook = onCleanup(@() close_system(syshandle, 0));
    assert_true(isclass(mdlWorkspace));



%% boilerplate code for testing functions that are private to assert functions
function set_up %#ok<DEFNU>

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    
    % buffer current path
    mlunit_param('usertest_isclass', pwd);
    cd(testdir);

function tear_down %#ok<DEFNU>

    % reset to previous dir
    cd(mlunit_param('usertest_isclass'));
