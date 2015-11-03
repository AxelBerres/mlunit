function test = test_errorfail_output %#ok<STOUT>

output_tests_from_mfile;

% This test will end up with a failure AND an error.

function test_success

    mlunit_fail();

function tear_down

    unknown_function_call();
