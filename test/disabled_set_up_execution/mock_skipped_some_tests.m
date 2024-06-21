function suite = mock_skipped_some_tests
    suite = load_tests_from_mfile(test_loader, 'skip', {'test_me'}, 'You but not me.');
end

function suite_set_up
end

function set_up
end

function test_me
    error('test_me not expected to run')
end

function test_you
end
