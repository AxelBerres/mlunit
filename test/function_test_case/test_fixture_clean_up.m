%Test data transfer between set_up and tear_down fixture only.

%#ok<*DEFNU>

function test = test_fixture_clean_up

test = load_tests_from_mfile(test_loader);


function data = set_up(~, test_name)

    data = struct();
    data.name = test_name;
    data.state = 'started';


function test_pass_through

    % nothing to be done here
    

function tear_down(data)

    assert_equals('test_pass_through', data.name);
    assert_equals('started', data.state);
