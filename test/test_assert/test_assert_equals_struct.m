function test = test_assert_equals_struct

test = load_tests_from_mfile(test_loader);


function test_equalStructArrays
   
   x = struct('field1', {1 2}, 'field2', {'a', 'c'});
   y = struct('field1', {1 2}, 'field2', {'a', 'c'});
   
   assert_equals(x,y);

function test_differentFieldOrder

    x = struct('a','','b','');
    y = struct('b','','a','');

    assert_equals(x,y);

function test_differentFieldnames

    x = struct('a','','b','');
    y = struct('c','','a','');

    assert_not_equals(x, y);

function test_additionalField

    x = struct('a','','b','');
    y = struct('b','','a','','c','');

    assert_not_equals(x, y);

function test_additionalFieldInSubstruct

    x.a = struct('a','','b','');
    y.a = struct('b','','a','','c','');

    assert_not_equals(x, y);
