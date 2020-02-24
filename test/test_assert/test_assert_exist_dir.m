function test = test_assert_exist_dir

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function test_empty_arguments

   assert_exist_dir();
   
function test_existing_dir

   assert_exist_dir(matlabroot);

function test_missing_dir

   assert_error(@() assert_exist_dir(tempname), 'MLUNIT:Failure');

function test_empty_string

   assert_error(@() assert_exist_dir(''), 'MLUNIT:Failure');
