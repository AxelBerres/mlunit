function test = test_assert_error

test = load_tests_from_mfile(test_loader);


function test_proper_errors

    % any error, resulting from wrong error call
    assert_error('error');
    assert_error(@() error());

    % by id, resulting from wrong error call
    assert_error('error', 'MATLAB:minrhs');
    assert_error(@() error(), 'MATLAB:minrhs');

    % by id, resulting from valid error call
    assert_error('error(''huh:ha'', '''');', 'huh:ha');
    assert_error(@() error('huh:ha', ''), 'huh:ha');

    % by other fields, resulting from valid error call
    assert_error('error(''huh\nha'');', struct('message', 'huh\nha'));
    assert_error('error(''huh\nha'');', struct('message', 'huh\nha', 'identifier', ''));
    assert_error(@() error('huh\nha'), struct('message', 'huh\nha', 'identifier', ''));

    % btw, error() without id does not sprintf its message, but error() with id does:
    assert_error(@() error('my:id', 'huh\nha'), struct('message', sprintf('huh\nha'), 'identifier', 'my:id'));

    % with variable injection
    v1 = 3; v2 = {};
    assert_error(@() max(v1, v2), 'MATLAB:UndefinedFunction');


function test_noargs

    bCaught = false;

    try
        assert_error();
    catch
        bCaught = true;
        l = lasterror();
        assert_equals(l.identifier, 'MATLAB:nargchk:notEnoughInputs');
    end

    if ~bCaught, fail(); end


function test_wrong_id

    bCaught = false;

    try
        assert_error(@() error(), 'wrong:id');
    catch
        bCaught = true;
        l = lasterror();
        assert_not_empty(strfind(l.message, 'Expected error identifier ''wrong:id'' actually was ''MATLAB:minrhs''.'));
    end

    if ~bCaught, fail(); end


function test_field_mismatch

    bCaught = false;

    try
        assert_error(@() error('huh\nha'), struct('message', 'wrong message', 'identifier', 'wrong:id'));
    catch
        bCaught = true;
        l = lasterror();
        assert_not_empty(strfind(l.message, 'Expected error identifier ''wrong:id'' actually was ''''.'));
        assert_not_empty(strfind(l.message, 'Expected error message ''wrong message'' actually was ''huh\nha''.'));
    end

    if ~bCaught, fail(); end
