function test = test_skip_and_fail

test = load_tests_from_mfile(test_loader);

function set_up
   

function tear_down

    error('unfinished tear down');

function test_A
   
    % passed

function test_B

    mlunit_skip();

function test_C

    mlunit_skip('Skip with reason');

function test_D

    mlunit_fail('Failed');
