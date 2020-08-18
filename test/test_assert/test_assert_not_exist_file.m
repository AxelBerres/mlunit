function test = test_assert_not_exist_file

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function test_empty_arguments

   assert_not_exist_file();
   
function test_existing_file

   file = fullfile(matlabroot, 'bin', 'lcdata.xml');
   assert_error(@() assert_not_exist_file(file), 'MLUNIT:Failure');

function test_missing_file

   assert_not_exist_file(tempname);

function test_empty_string

   assert_not_exist_file('');
