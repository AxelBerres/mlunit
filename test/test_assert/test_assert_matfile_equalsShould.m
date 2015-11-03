function test = test_assert_matfile_equalsShould %#ok<STOUT>
    output_tests_from_mfile;
   
function set_up
    basepath = fileparts(mfilename('fullpath'));
    addpath(fullfile(basepath, 'Data4_assert_matfile_equals'));
    
function tear_down
    basepath = fileparts(mfilename('fullpath'));
    rmpath(fullfile(basepath, 'Data4_assert_matfile_equals'));


function test_failIfNoFilesAreGiven
    assert_error('assert_matfile_equals(''du'',''testFile1.mat'')');
%end of function    

function test_failIfNoStringsAreUsed
    assert_error('assert_matfile_equals(1,''testFile1.mat'')');
%end of function    

function test_failIfASignalIsMissing
    assert_error('assert_matfile_equals( ''reference.mat'',''missingSignal.mat'')');
%end of function    

function test_failIfThereisAnExtraSignal
    assert_error('assert_matfile_equals( ''missingSignal.mat'', ''reference.mat'')');
%end of function

function test_failIfSignalsDiffer
    assert_error('assert_matfile_equals( ''differentValue.mat'', ''reference.mat'')');
%end of function    

function test_passIfFilesAreEqual
    assert_matfile_equals( 'reference.mat','equal2Reference.mat');
%end of function    