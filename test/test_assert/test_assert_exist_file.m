function test = test_assert_exist_file

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function test_empty_arguments

   assert_exist_file();
   
function test_existing_file

   file = fullfile(matlabroot, 'bin', 'lcdata.xml');
   assert_exist_file(file);

function test_missing_file

   assert_error(@() assert_exist_file(tempname), 'MLUNIT:Failure');

function test_empty_string

   assert_error(@() assert_exist_file(''), 'MLUNIT:Failure');

function test_assert_not_exist

   assert_exist_file(tempname, 0);

function test_assert_not_exist_fail

   file = fullfile(matlabroot, 'bin', 'lcdata.xml');
   assert_error(@() assert_exist_file(file, 0), 'MLUNIT:Failure');
