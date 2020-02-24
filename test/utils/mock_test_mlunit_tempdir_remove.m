function test = mock_test_mlunit_tempdir_remove

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

% Keep tempdir fid open in order to block tempdir removal by mlUnit.
% This provokes an error when mlUnit tries to remove tempdir after having executed the
% test and the test's tear_down method (empty).
% Cleanup in outside test_mlunit_tempdir.
function test_tempdir_error_remove

    tempdir = mlunit_tempdir();
    assert_exist_dir(tempdir, 'mlunit_tempdir failed to create dir');
    
    filepath = fullfile(tempdir, 'somefile.txt');
    fid = fopen(filepath, 'w');
    fprintf(fid, 'Hello\n');
    
    loc_capsule(struct('fid', fid, 'tempdir', tempdir));
    
function out = loc_capsule(in)

    persistent state;
    if isempty(state)
        state = '';
    end

    if nargin==1
        state = in;
    end
    
    out = state;
