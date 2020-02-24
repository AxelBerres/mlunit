function test = test_assert_contains

test = load_tests_from_mfile(test_loader);
%#ok<*DEFNU>

function test_insufficient_arguments

    assert_contains();
    assert_contains('hi');
    assert_contains({});
    assert_contains([]);
    
function test_empty_arguments
    
    assert_failure(@() assert_contains('', ''));
    assert_failure(@() assert_contains('hi', ''));
    assert_failure(@() assert_contains('', 'hi'));
    assert_failure(@() assert_contains({'foo', 'bar'}, ''));
    
function test_wrong_arguments

    assert_error(@() assert_contains([3, 4], 3));
    assert_error(@() assert_contains('hi', 3));

function test_nominal

    assert_contains('hi', 'hi');
    assert_contains('hello', 'l');
    assert_contains(sprintf('foo\nbar'), char(10));

function test_no_match

    assert_failure(@() assert_contains('hi', 'ho'));
    
function test_cellinput

    assert_contains({'foo', 'bar'}, 'oo');

function test_cellinput_no_match

    assert_failure(@() assert_contains({'foo', 'bar'}, 'oob'));


function assert_failure(fhandle)

    assert_error(fhandle, 'MLUNIT:Failure');
