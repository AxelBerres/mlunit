%Test data transfer between set_up, test functions, and tear_down in function test
%cases.

%#ok<*DEFNU>

function test = test_data_propagation

test = load_tests_from_mfile(test_loader);


function data = set_up(test_name)

    data = struct();
    data.name = test_name;
    data.state = 'started';


function data_out = test_set_up_data(data_in)

    assert_equals('test_set_up_data', data_in.name)
    assert_equals('started', data_in.state);
    data_out = 'tested';


function data_out = test_data_independency(data_in)

    assert_equals('test_data_independency', data_in.name)
    assert_equals('started', data_in.state);
    data_out = 'finished';


function tear_down(data)

    assert_contains({'finished', 'tested'}, data);
