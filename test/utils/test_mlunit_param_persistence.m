% Test mlunit_param persistence.
% Even faced with calls to clear, javaaddpath or some such, parameters must
% still be present.
function test = test_mlunit_param_persistence  %#ok<STOUT>

output_tests_from_mfile;

% define unique parameter in order to detect reset when it turns out absent
mlunit_param('mlunittest_persistence', 42);


function set_up

    % reset persistent states
    clear('functions');

function test_persistence

    assert_equals(42, mlunit_param('mlunittest_persistence'));
