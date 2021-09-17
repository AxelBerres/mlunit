function test = test_mlunit_tempdir

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function suite_set_up

    loc_capsule('');
    
    suitetempdir = mlunit_tempdir();
    mlunit_param('test_mlunit_tempdir', suitetempdir);

function test_creation

    tempdir = mlunit_tempdir();
    loc_capsule(tempdir);
    assert_exist_dir(tempdir, 'mlunit_tempdir failed to create dir');
    assert_exist_dir(mlunit_param('test_mlunit_tempdir'), 'suite temp dir missing');

% Requires this test to run AFTER test_tempdir_create
function test_automatic_remove

    tempdir = loc_capsule();
    assert_equals(0, exist(tempdir, 'dir'), 'test_one''s tempdir still exists: %s', tempdir);
    assert_exist_dir(mlunit_param('test_mlunit_tempdir'), 'suite temp dir missing');
    
    % reset capsule
    loc_capsule('');

% Keep tempdir file handle open in order to block tempdir removal by mlUnit.
% Cleanup in next test.
function test_error_remove

    results = run_suite(mlunit_suite_runner, 'mock_test_mlunit_tempdir_remove');
    
    % expecting 1 test result, containing an error
    assert_equals(1, numel(results), 'Unexpected number of tests in mock_test_mlunit_tempdir_remove');
    assert_equals('test_tempdir_error_remove', results(1).name);
    assert_empty(results(1).failure, 'Unexpected failure in mock_test_mlunit_tempdir_remove');
    
    expected_errors = 1;
    if isunix
        % Linux is actually fine with removing currently open files
        expected_errors = 0;
    end
    assert_equals(expected_errors, numel(results(1).errors), 'Unexpected number of errors in mock rmdir test.');
    
    % check expected error message
    expected_msg_front = sprintf([...
        'Error(s) during environment reset after tear_down fixture. Maybe due to open file handles? Models left in compile state?\n' ...
        'Error removing temporary directory:'
        ]);
    errormsg = get_message_with_stack(results(1).errors{1});
    assert_equals(expected_msg_front, errormsg(1:numel(expected_msg_front)), 'Unexpected error message start');
    assert_not_empty(strfind(errormsg, 'MATLAB:RMDIR:NoDirectoriesRemoved'), 'Could not find message ID MATLAB:RMDIR:NoDirectoriesRemoved in error message.');
    
% Clean up fid and tempdir left open by test_tempdir_error_remove.
% Requires that test_tempdir_error_remove has run before.
function test_error_remove_cleanup

    cleanupinfo = feval(mlunit_get_subfunction_handle('mock_test_mlunit_tempdir_remove', 'loc_capsule'));
    if ~isstruct(cleanupinfo)
        error('Unexpected cleanup information. Likely because the preceding mock test failed early.');
    end
    assert_equals(0, fclose(cleanupinfo.fid), 'Could not close file handle from previous test.');
    [status, msg, msgid] = rmdir(cleanupinfo.tempdir, 's');
    if ispc
        % Linux already deleted this
        assert_equals(1, status, 'Ultimate removal of tempdir did not succeed.\n  dir:%s\n  msg:%s\n  id :%s', cleanupinfo.tempdir, msg, msgid);
    end
    assert_equals(0, exist(cleanupinfo.tempdir, 'dir'), 'mlUnit controlled tempdir was not deleted.');
    
function test_error_mkdir

    % load stubs
    mfileDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(mfileDir, 'test_mlunit_tempdir_stubs'));

    % second mlunit_tempdir will try to create the same directory as the first call
    mlunit_tempdir();
    assert_error(@() mlunit_tempdir(), 'MLUNIT:TempdirCollision');
    
    % clear persistent value
    clear tempname

function test_unzip

    source_zip = fullfile('test_mlunit_tempdir_data', 'zipdata.zip');
    tempdir = mlunit_tempdir(source_zip);
    
    expected_files = {};
    expected_files{1} = fullfile(tempdir, 'ziphello.txt');
    expected_files{2} = fullfile(tempdir, 'zipnested', 'zipworld.txt');
    
    assert_exist_file(expected_files{1});
    assert_exist_file(expected_files{2});

function test_copydir

    source_dir = fullfile('test_mlunit_tempdir_data', 'files');
    tempdir = mlunit_tempdir(source_dir);
    
    expected_files = {};
    expected_files{1} = fullfile(tempdir, 'hello.txt');
    expected_files{2} = fullfile(tempdir, 'world.txt');
    
    assert_exist_file(expected_files{1});
    assert_exist_file(expected_files{2});

function test_copyfile_absolute

    basedir = fileparts(mfilename('fullpath'));
    source_file = fullfile(basedir, 'test_mlunit_tempdir_data', 'files', 'hello.txt');
    tempdir = mlunit_tempdir(source_file);
    expected_file = fullfile(tempdir, 'hello.txt');
    
    assert_exist_file(expected_file);

function test_copyfile_relative

    source_file = fullfile('test_mlunit_tempdir_data', 'files', 'hello.txt');
    tempdir = mlunit_tempdir(source_file);
    expected_file = fullfile(tempdir, 'hello.txt');
    
    assert_exist_file(expected_file);

% mixed copy file, copy dir, unzip; absolute, relative paths
function test_copy_multiple_items

    source_zip = fullfile('test_mlunit_tempdir_data', 'zipdata.zip');
    source_dir = 'test_mlunit_tempdir_data';
    basedir = fileparts(mfilename('fullpath'));
    source_file = fullfile(basedir, 'test_mlunit_tempdir_data', 'files', 'hello.txt');

    tempdir = mlunit_tempdir(source_dir, source_file, source_zip);
    
    expected_file = fullfile(tempdir, 'hello.txt');
    assert_exist_file(expected_file);
    
    expected_dir_files = {};
    expected_dir_files{1} = fullfile(tempdir, 'zipdata.zip');
    expected_dir_files{2} = fullfile(tempdir, 'files', 'world.txt');
    assert_exist_file(expected_dir_files{1});
    assert_exist_file(expected_dir_files{2});
    
    expected_zip_files = {};
    expected_zip_files{1} = fullfile(tempdir, 'ziphello.txt');
    expected_zip_files{2} = fullfile(tempdir, 'zipnested', 'zipworld.txt');
    assert_exist_file(expected_zip_files{1});
    assert_exist_file(expected_zip_files{2});
    
    
function out = loc_capsule(in)

    persistent state;
    if isempty(state)
        state = '';
    end

    if nargin==1
        state = in;
    end
    
    out = state;
