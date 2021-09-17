% Count set_up and tear_down calls and check that they are only called for non-disabled
% tests.
function suite = mock_disabled_some_tests
    suite = load_tests_from_mfile(test_loader);
    suite = disable_tests(suite, {'test_me'});
end

%#ok<*DEFNU>

function suite_set_up
    loc_count('reset');
    loc_count(1);
end

function set_up
    loc_count(1);
end

function tear_down
    loc_count(1);
end

function suite_tear_down
    loc_count(1);
    % should have execute suite_set_up, set_up, tear_down, suite_tear_down once each
    if 4 ~= loc_count
        error('unexpected');
    end
end

function test_me
    error('test_me not expected to run')
end

function test_you
    % should have execute suite_set_up and set_up once each
    assert_equals(2, loc_count);
end

function out = loc_count(increment)
    
    reset = nargin == 1 && ischar(increment) && strcmpi('reset', increment);

    persistent counter;
    if isempty(counter) || reset
        counter = 0;
    end
    
    if ~reset && nargin == 1
        counter = counter + increment;
    end
    
    out = counter;
end
