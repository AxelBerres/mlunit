function tests = test_callchain

tests = load_tests_from_mfile(test_loader);

disp('Stages of function test suite execution:');
disp('- suite load');

function suite_set_up

    disp('- suite setup');
        
function suite_tear_down

    disp('- suite teardown');
    
function set_up

    disp('- setup');
        
function tear_down

    disp('- teardown');
    
function test_one

    disp('- one test');
    
function test_another

    disp('- another test');
