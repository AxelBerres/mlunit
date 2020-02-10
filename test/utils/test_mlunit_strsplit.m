function test = test_mlunit_strsplit

test = load_tests_from_mfile(test_loader);

function test_empty

    assert_equals({}, mlunit_strsplit());
    assert_equals({''}, mlunit_strsplit(''));
    
function test_only_separators

    assert_equals({'', ''}, mlunit_strsplit('t', 't'));
    assert_equals({'', '', ''}, mlunit_strsplit('tt', 't'));
    
function test_empty_separator

    assert_equals({'abc'}, mlunit_strsplit('abc', ''));
    
function test_default_separator

    assert_equals({'a', 'b', 'c'}, mlunit_strsplit('a,b,c'));
    
function test_nominal
    
    assert_equals({'a', 'b', 'c'}, mlunit_strsplit('a;b;c', ';'));

function test_multichar_separator
    
    assert_equals({'a', 'b', 'c'}, mlunit_strsplit('a::b::c', '::'));
    assert_equals({'a'}, mlunit_strsplit('a', '::'));

function test_wrong_list_type

    assert_error(@() mlunit_strsplit({'abc'}));
    assert_error(@() mlunit_strsplit(3));
    assert_error(@() mlunit_strsplit([]));

function test_wrong_separator_type

    assert_error(@() mlunit_strsplit('abc', 3));
    assert_error(@() mlunit_strsplit('abc', []));
    assert_error(@() mlunit_strsplit('abc', {','}));
