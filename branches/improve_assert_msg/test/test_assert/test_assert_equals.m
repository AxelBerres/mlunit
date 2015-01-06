function test = test_assert_equals

test = load_tests_from_mfile(test_loader);


function test_equals_on_empty

   double_test_equal_arguments([], []);
   double_test_equal_arguments('', '');
   double_test_equal_arguments({}, {});
   double_test_equal_arguments(struct([]), struct([]));


function test_equals_array

   double_test_equal_arguments(3, [3]);
   m = magic(5);
   double_test_equal_arguments(m, m);


function test_equals_mixed_input

   % char and numeric often compare to equal
   double_test_equal_arguments([], '');
   double_test_equal_arguments([65], 'A');


function test_equals_string

   s = ['hello';'world'];
   double_test_equal_arguments(s, s);


function test_equals_cell

   double_test_equal_arguments({3}, {3});
   double_test_equal_arguments({'ho'}, {'ho'});


function test_equals_struct

   s = struct('a', {42});
   double_test_equal_arguments(s, s);


function test_equals_complex

   c = cell(2);
   c{1} = [42 23];
   c{2} = 4+3i;
   c{3} = 'hello';
   c{4} = struct('a', {{'hi', 'ho'}}, 'b', {[3 4]});
   double_test_equal_arguments(c, c);


function test_equals_eps

   double_test_equal_arguments(0.3, 0.1+0.2, eps(0.3));
   double_test_equal_arguments(0.3, 0.31, 0.01 + eps(0.3));
   double_test_equal_arguments(0.5, 0.25, 0.25);


% helper for asserting assert_equals to succeed and assert_not_equals to fail
function double_test_equal_arguments(varargin)

   assert_equals(varargin{:});
   assert_error(@() assert_not_equals(varargin{:}));
