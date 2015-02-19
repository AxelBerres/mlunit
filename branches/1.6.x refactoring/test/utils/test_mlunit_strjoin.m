function test = test_mlunit_strjoin

test = load_tests_from_mfile(test_loader);

function test_empty

    assert_equals('', mlunit_strjoin());
    assert_equals('', mlunit_strjoin({}));
    assert_equals('', mlunit_strjoin({''}));
    assert_equals('', mlunit_strjoin({'', ''}, ''));
    
function test_empty_separator

    assert_equals('abc', mlunit_strjoin({'a', 'b', 'c'}, ''));
    
function test_default_separator

    assert_equals('a, b, c', mlunit_strjoin({'a', 'b', 'c'}));
    
function test_nominal
    
    assert_equals('a;b;c', mlunit_strjoin({'a', 'b', 'c'}, ';'));

function test_multichar_separator
    
    assert_equals('a::b::c', mlunit_strjoin({'a', 'b', 'c'}, '::'));
    assert_equals('a', mlunit_strjoin({'a'}, '::'));

function test_wrong_list_type

    assert_error(@() mlunit_strjoin('abc'));
    assert_error(@() mlunit_strjoin(3));
    assert_error(@() mlunit_strjoin([]));

function test_wrong_separator_type

    assert_error(@() mlunit_strjoin({'abc'}, 3));
    assert_error(@() mlunit_strjoin({'abc'}, []));
    assert_error(@() mlunit_strjoin({'abc'}, {','}));
