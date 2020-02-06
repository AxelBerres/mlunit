function test = test_suite_collection_output %#ok<STOUT>

output_tests_from_mfile;

function suite_set_up
   disp('Suite set up');

function suite_tear_down
   disp('Suite tear down');

function set_up
   fprintf('\n');
   disp('Test set up');

function tear_down
   disp('Test tear down');

function test_A
   disp('Test A execution');

function test_B
   disp('Test B execution');
