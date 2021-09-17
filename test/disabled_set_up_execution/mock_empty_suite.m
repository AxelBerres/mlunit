function test = mock_empty_suite
    test = load_tests_from_mfile(test_loader);
end

function suite_set_up
    error('suite_set_up not expected to run')
end

function set_up
    error('set_up not expected to run')
end
