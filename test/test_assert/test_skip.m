function test = test_skip %#ok<STOUT>
%test_skip test skips.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_skip');
%
%  See also MLUNIT_SKIP, TEST_TEST_CASE/TEST_SKIP.

output_tests_from_mfile;
%#ok<*CTCH>

function test_normal_skip

failed = true;
try
    mlunit_skip();
    failed = false;
catch 
end
assert_true(failed, 'mlunit_skip fails to fail.');
l = lasterror;
assert_equals('MLUNIT:Skipped', l.identifier);
