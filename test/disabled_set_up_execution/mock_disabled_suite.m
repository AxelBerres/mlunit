function suite = mock_disabled_suite
    suite = load_tests_from_mfile(test_loader);
    suite = disable_tests(suite, {'test_me', 'test_you'});
end

function suite_set_up
    error('suite_set_up not expected to run')
end

function set_up
    error('set_up not expected to run')
end

function test_me
    error('test_me not expected to run')
end

function test_you
    error('test_me not expected to run')
end
