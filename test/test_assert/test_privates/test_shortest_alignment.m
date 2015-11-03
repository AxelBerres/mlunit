function test = test_shortest_alignment %#ok<STOUT>

output_tests_from_mfile;


function test_empty

    assert_alignment('', '', '');

function test_nochange

    alignment = ['foo';
                 'foo'];
    assert_alignment('foo', 'foo', alignment);

function test_allchanged

    alignment = ['foo';
                 'bar'];
    assert_alignment('foo', 'bar', alignment);

function test_onechanged

    alignment = ['hip';
                 'hop'];
    assert_alignment('hip', 'hop', alignment);
    
function test_deletion

    alignment = ['sesame';
                 'se·am·'];
    assert_alignment('sesame', 'seam', alignment);

function test_insertion

    alignment = ['b·ar·';
                 'bears'];
    assert_alignment('bar', 'bears', alignment);
    
function test_favor_change_no_transposition

    alignment = ['ae';
                 'ea'];
    assert_alignment('ae', 'ea', alignment);
    
function test_complex_edit

    alignment = ['GCAG·TGCU';
                 'G·AGTTACA'];
    assert_alignment('GCAGTGCU', 'GAGTTACA', alignment);


%% local assert function
function assert_alignment(s1, s2, expected_alignment)

    actual_alignment = shortest_alignment(s1, s2);
    assert_equals(expected_alignment, actual_alignment);


%% boilerplate code for testing functions that are private to assert functions
function set_up %#ok<DEFNU>

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    cd(testdir);
