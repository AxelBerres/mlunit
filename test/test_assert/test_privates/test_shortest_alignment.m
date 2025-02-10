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

function test_large_edit_runtime

   % Compare two random gene sequences of 512 characters length
   repeats = 4;
   seed1 = 'ACCGCTGTGTAGCGGACAGTCTGAGCTACCCTCTCAAGCACGAGATCTACAGGGCGGGGTAGAAGCCGTCGCTTCGGGTCCATGCGGGGGGTAAAACCCTGTTTAAGAGGTCCGGGCAGCATACGCGC';
   seed2 = 'GGCACCCATCTCTCTTCATTCGCTTATTGTGAACGTTCGAAAGCACAATGTGGTTTATGTGCTACTGTGGAGAGGGTTTGTGAATCTAGGAGCACAAAAAAGCGGCGCACTTCAGGCATAAAAGGAGC';
   seq1 = repmat(seed1, 1, repeats);
   seq2 = repmat(seed2, 1, repeats);
   
   before = cputime;
   shortest_alignment(seq1, seq2);
   passed = cputime - before;
   assert_true(passed < 4, 'shortest_alignment is expected to finish during 4s on strings that are %d characters long. But it used %.1fs.', repeats*numel(seed1), passed);


%% local assert function
function assert_alignment(s1, s2, expected_alignment)

    actual_alignment = shortest_alignment(s1, s2);
    assert_equals(expected_alignment, actual_alignment);


%% boilerplate code for testing functions that are private to assert functions
function set_up %#ok<DEFNU>

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    cd(testdir);
