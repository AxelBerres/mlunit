function test = test_assert_warning %#ok<STOUT>

output_tests_from_mfile;


function test_proper_warning %#ok<DEFNU>

    % including variable injection
    wrongpath = 'arbitrary/path/that/should/not/exist';
    assert_warning(@() rmpath(wrongpath), 'MATLAB:rmpath:DirNotFound');


function test_noargs %#ok<DEFNU>

    bCaught = false;

    try
        assert_warning();
    catch
        bCaught = true;
        l = lasterror();
        assert_equals(l.identifier, 'MATLAB:NotEnoughInputs');
    end

    if ~bCaught, mlunit_fail(); end


function test_wrong_id %#ok<DEFNU>

    bCaught = false;

    % Turn off immanent warning. assert_warning will not do it, because we call
    % it with another id.
    prevwarn = warning('off', 'MATLAB:rmpath:DirNotFound');
    
    try
        wrongpath = 'arbitrary/path/that/should/not/exist';
        assert_warning(@() rmpath(wrongpath), 'wrong:id');
    catch
        bCaught = true;
        warning(prevwarn);
        l = lasterror();
        % function string contains a whitespace after '@()' on R2006b,
        % but does not on R2007b and later.
        assert_not_empty(regexp(l.message, 'No warning wrong:id when executing function @\(\)[ ]?rmpath\(wrongpath\)\.'));
    end

    if ~bCaught, mlunit_fail(); end
