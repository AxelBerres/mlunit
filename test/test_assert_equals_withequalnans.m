function test = test_assert_equals_withequalnans

test = load_tests_from_mfile(test_loader);


function test_equal_nans

   % NaNs are treated as different by default
   assert_not_equals([1 2 NaN 4], [1 2 NaN 4]);
   % NaNs are equal with this method
   assert_equals_withequalnans([1 2 NaN 4], [1 2 NaN 4]);
   % still, one NaN does not equal any value
   assert_not_equals_withequalnans([1 2 3 4], [1 2 NaN 4]);


function test_equal_nans_eps

   % differences in values may mix with NaN equality
   assert_not_equals_withequalnans([1.1 NaN 0.5], [1.2 NaN 0.4]);
   % eps checking may mix with NaN equality
   assert_equals_withequalnans([1.1 NaN 0.5], [1.2 NaN 0.4], 0.1);
   % still, one NaN does not equal any value
   assert_not_equals_withequalnans([1.1 6.0 0.5], [1.2 NaN 0.4], 0.1);
