function test = test_assert_not_equals

test = load_tests_from_mfile(test_loader);


function test_not_equals

   double_test_different_arguments(3, {3});


function test_not_equals_on_empty

   double_test_different_arguments([], 3);
   double_test_different_arguments('', 3);
   double_test_different_arguments({}, 3);
   double_test_different_arguments(struct([]), 3);


function test_not_equals_eps

   % not equal because eps too small
   double_test_different_arguments(0.3, 0.31, 0.0099);


% helper for asserting assert_not_equals to succeed and assert_equals to fail
function double_test_different_arguments(varargin)

   assert_not_equals(varargin{:});
   assert_error(@() assert_equals(varargin{:}));
