% Test mlunit_param function.
% Be careful here, because we test a function that mlUnit uses for work at the
% same time.
function test = test_mlunit_param  %#ok<STOUT>

output_tests_from_mfile;
    

function test_single_param

    pname = 'someparam';
    pvalue = 42;

    assert_not_equals(pvalue, mlunit_param(pname));
    mlunit_param(pname, pvalue);
    assert_equals(pvalue, mlunit_param(pname));

function test_single_undefined

    assert_equals([], mlunit_param('previously_unknown'));

function test_single_defaults

    mlunit_param(struct());
    assert_equals(false, mlunit_param('equal_nans'));

function test_single_nonvarname

    pname = '1 some strange $'' parameter NAME';
    pvalue = 42;

    assert_not_equals(pvalue, mlunit_param(pname));
    mlunit_param(pname, pvalue);
    assert_equals(pvalue, mlunit_param(pname));

function test_single_name_collision

    % construct two parameter names that differ only after the namelengthmax
    % restriction, typically after the 63rd character
    seed = 'abc';
    namebase = repmat(seed, 1, ceil(namelengthmax/length(seed)) + 1);
    name1 = [namebase(1:namelengthmax) 'x'];
    name2 = [namebase(1:namelengthmax) 'd'];
    val1 = 'foo';
    val2 = 'bar';

    assert_not_equals(val1, mlunit_param(name1));
    assert_not_equals(val2, mlunit_param(name2));

    mlunit_param(name1, val1);
    mlunit_param(name2, val2);

    % because genvarname just cuts off after namelengthmax,
    % name1 and name2 actually collide and we overwrote val1 with val2:
    assert_not_equals(val1, mlunit_param(name1));
    assert_equals(val2, mlunit_param(name2));

function test_noargs

    result = mlunit_param();
    assert_true(isstruct(result));

function test_noargs_with_parameter

    pname = 'myuniqueparameter';
    pvalue = 42;
    mlunit_param(pname, pvalue);

    result = mlunit_param();
    assert_true(isfield(result, pname));
    assert_equals(pvalue, result.(pname));

function test_default_values
    
    mlunit_param(struct());
    assert_true(mlunit_param('abbrev_trace'));
    assert_false(mlunit_param('equal_nans'));
