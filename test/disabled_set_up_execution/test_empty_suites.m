function suite = test_empty_suites
    suite = load_tests_from_mfile(test_loader);
end

%#ok<*DEFNU>

function test_empty_suite
    results = run_suite(mlunit_suite_runner, mock_empty_suite);
    assert_no_issues(results);
end

function test_disabled_suite
    results = run_suite(mlunit_suite_runner, mock_disabled_suite);
    assert_no_issues(results);
end

function test_disabled_suite_all
    results = run_suite(mlunit_suite_runner, mock_disabled_suite_all);
    assert_no_issues(results);
end

% Test that for disabled tests no set_up or tear_down execute, when
% there are tests in the suite that do execute.
function test_disabled_some_tests
    results = run_suite(mlunit_suite_runner, mock_disabled_some_tests);
    assert_no_issues(results);
end

function assert_no_issues(results)
    nrissues = 0;
    firstmsg = '';

    % only actually access fields if they exist
    if isfield(results, 'errors')
        idx_errors = find(~arrayfun(@(x)isempty(x.errors), results));
    
        nrissues = nrissues + numel(idx_errors);
        if ~isempty(idx_errors)
            firstmsg = get_message_with_stack(results(idx_errors(1)).errors{1});
        end
    end
    
    if isfield(results, 'failure')
        idx_fails = find(~arrayfun(@(x)isempty(x.failure), results));
        
        nrissues = nrissues + numel(idx_fails);
        if ~isempty(idx_fails) && isempty(firstmsg)
            firstmsg = results(idx_fails(1)).failure;
        end
    end
    
    if nrissues > 0
        mlunit_fail('The mock suite should not have issues, but reported %i issues. First issue:\n%s', nrissues, firstmsg);
    end
end
