function test = test_strjoin

test = load_tests_from_mfile(test_loader);

function test_empty

    assert_equals('', strjoin());
    assert_equals('', strjoin({}));
    assert_equals('', strjoin({''}));
    assert_equals('', strjoin({'', ''}, ''));
    
function test_empty_separator

    assert_equals('abc', strjoin({'a', 'b', 'c'}, ''));
    
function test_default_separator

    assert_equals('a, b, c', strjoin({'a', 'b', 'c'}));
    
function test_nominal
    
    assert_equals('a;b;c', strjoin({'a', 'b', 'c'}, ';'));

function test_multichar_separator
    
    assert_equals('a::b::c', strjoin({'a', 'b', 'c'}, '::'));
    assert_equals('a', strjoin({'a'}, '::'));

function test_wrong_list_type

    assert_error(@() strjoin('abc'), 'MATLAB:assert:failed');
    assert_error(@() strjoin(3), 'MATLAB:assert:failed');
    assert_error(@() strjoin([]), 'MATLAB:assert:failed');

function test_wrong_separator_type

    assert_error(@() strjoin({'abc'}, 3), 'MATLAB:assert:failed');
    assert_error(@() strjoin({'abc'}, []), 'MATLAB:assert:failed');
    assert_error(@() strjoin({'abc'}, {','}), 'MATLAB:assert:failed');


%% boilerplate code to enable testing the private strjoin
function set_up

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    
    % buffer current path
    loc_path_capsule(pwd);
    
    cd(testdir);

function tear_down

    % reset to previous dir
    cd(loc_path_capsule());

% Return last stored path string. Empty string if none stored.
% Provide path string argument for storage. If used with argument,
% the returned path is the previous path.
function pout = loc_path_capsule(pin)

    assert(nargin==0 || ischar(pin));

    persistent stored_path;
    if isempty(stored_path)
        stored_path = '';
    end
    
    pout = stored_path;
    
    if nargin >= 1
        stored_path = pin;
    end
