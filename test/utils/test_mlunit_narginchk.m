function test = test_mlunit_narginchk %#ok<STOUT>

output_tests_from_mfile;

function test_misuse

    assert_nargchk_error({}, 'MATLAB:NotEnoughInputs');
    % this one actually gets thrown by MATLAB instead of mlunit_narginchk
    assert_nargchk_error({1,2,3,4}, 'MATLAB:TooManyInputs');
    assert_nargchk_error({1,2,[3,4]}, 'MATLAB:ScalIntReq');
    
function test_properuse

    mlunit_narginchk(1,1,1);
    mlunit_narginchk('h','h','h');
    mlunit_narginchk(2,4,3);
    
function test_checkfails

    assert_nargchk_error({2,4,1}, 'MATLAB:NotEnoughInputs');
    assert_nargchk_error({4,2,3}, 'MATLAB:NotEnoughInputs');
    
    assert_nargchk_error({2,4,5}, 'MATLAB:TooManyInputs');
    
function test_string_output

    assert_equals('Not enough input arguments.', mlunit_narginchk(2,4,1));
    assert_equals('Too many input arguments.', mlunit_narginchk(2,4,5));
    
function assert_nargchk_error(args, errid)

    % delegate error to assert_error in order to get its nice output
    errfun = @()true;
    try
        mlunit_narginchk(args{:});
    catch me
        errfun = @()rethrow(me);
    end
    
    assert_error(errfun, errid);
