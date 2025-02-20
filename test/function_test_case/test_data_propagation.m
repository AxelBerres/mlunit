%Test data transfer between set_up, test functions, and tear_down in function test
%cases.

%#ok<*DEFNU>

function test = test_data_propagation

test = load_tests_from_mfile(test_loader);


function data_out = suite_set_up(data_in, test_name)

    data_out = struct();
    data_out.name_suite_set_up = test_name;
    data_out.data_suite_set_up = data_in;


function data = set_up(data, test_name)

    data.name = test_name;
    data.state = 'started';


function data_out = test_set_up_data(data_in, test_name)

    assert_equals('test_set_up_data', test_name)
    assert_equals('test_set_up_data', data_in.name)
    assert_equals('suite_set_up', data_in.name_suite_set_up)
    assert_equals([], data_in.data_suite_set_up)
    assert_equals('started', data_in.state)
    data_out = 'tested';


function data_out = test_data_independency(data_in)

    assert_equals('test_data_independency', data_in.name)
    assert_equals('started', data_in.state);
    data_out = 'finished';


function tear_down(data, test_name)

    assert_contains({'finished', 'tested'}, data)
    assert_contains({'test_set_up_data', 'test_data_independency'}, test_name)

function suite_tear_down(data)

    assert_equals(2, numel(fieldnames(data)))
    assert_equals([], data.data_suite_set_up)
