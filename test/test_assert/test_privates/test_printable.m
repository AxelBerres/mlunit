function test = test_printable

    test = load_tests_from_mfile(test_loader);
    %#ok<*DEFNU>

function test_empty

    assert_equals('[]', printable([]));
    assert_equals('[]', printable(repmat(NaN,0,1)));


function test_cell_empty

    assert_equals('{}', printable({}));
    assert_equals('{}', printable(cell(0,1)));

function test_cell_single

    assert_equals('{1}', printable({1}));
    assert_equals('{NaN}', printable({nan}));

function test_cell_vector

    assert_equals('{1, 2}', printable({1 2}));
    assert_equals('{1; 2}', printable({1;2}));

function test_cell_matrix

    % 2D
    assert_equals('{1, 2; 3, 4}', printable({1 2; 3, 4}));
    
    % 3D
    c(:,:,1) = {1, 2; 3, 4};
    c(:,:,2) = {5, 6; 7, 8};
    assert_equals('{1, 2; 3, 4; 5, 6; 7, 8}', printable(c));

function test_cell_complex

    assert_equals('{1, {2, [{three:4}]}; 5, ''six''}', printable({1 {2, struct('three', 4)}; 5, 'six'}));


%% boilerplate code for testing functions that are private to assert functions
function set_up

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    cd(testdir);
