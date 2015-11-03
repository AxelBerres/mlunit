function test = test_printable %#ok<STOUT>

output_tests_from_mfile;


function test_empty

    assert_equals('[]', printable([]));
    assert_equals('[]', printable(repmat(NaN,0,1)));


%% boilerplate code for testing functions that are private to assert functions
function set_up %#ok<DEFNU>

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    cd(testdir);
