function test = test_assert_equals_withequalnans %#ok<STOUT>

output_tests_from_mfile;


function test_equal_nans

   % NaNs are treated as different by default
   old_eqnans = mlunit_param('equal_nans', false);
   assert_not_equals([1 2 NaN 4], [1 2 NaN 4]);

   % NaNs are equal with this setting
   mlunit_param('equal_nans', true);
   assert_equals([1 2 NaN 4], [1 2 NaN 4]);
   % still, one NaN does not equal any value
   assert_not_equals([1 2 3 4], [1 2 NaN 4]);

   % revert parameter
   mlunit_param('equal_nans', old_eqnans);


function test_equal_nans_eps

   old_eqnans = mlunit_param('equal_nans', true);

   % differences in values may mix with NaN equality
   assert_not_equals([1.1 NaN 0.5], [1.2 NaN 0.4]);
   % eps checking may mix with NaN equality
   assert_equals([1.1 NaN 0.5], [1.2 NaN 0.4], 0.1);
   % still, one NaN does not equal any value
   assert_not_equals([1.1 6.0 0.5], [1.2 NaN 0.4], 0.1);

   % revert parameter
   mlunit_param('equal_nans', old_eqnans);
