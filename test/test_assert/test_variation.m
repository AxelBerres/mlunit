function test = test_variation

test = load_tests_from_mfile(test_loader);

%#ok<*DEFNU>
%#ok<*SPRINTFN>


%% Tests
function test_error_too_few_arguments
    
    assert_error(@()mlunit_variation(@loc_assert_foo));

function test_no_run_when_empty

    mlunit_variation(@loc_assert_equals, {});
    mlunit_variation(@loc_assert_equals, []);
    mlunit_variation(@loc_assert_equals, [], {}, {});
    
function test_vary_sequentially

    mlunit_variation(@loc_assert_foo, {'foo', 'foo'});
    mlunit_variation(@loc_assert_equals, [1,2,3], [1,2,3], [1,2,3]);
    mlunit_variation(@loc_assert_equals, {'foo', 'bar'}, {'foo', 'bar'});

function test_scalar_expansion

    % must produce 2 variations, all passing
    mlunit_variation(@loc_assert_equals, [pi,pi], {pi,pi}, pi);

function test_char_expansion

    expected_error = struct();
    expected_error.identifier = 'MLUNIT:Failure';
    expected_error.message = mlunit_strjoin({...
        '- Variation {''world'', ''oob''} FAIL', ...
        '    Expected pattern ''oob'' not found in text:', ...
        '    [''world'']', ...
        }, sprintf('\n'));
    assert_error(@()mlunit_variation(@assert_contains, {'foobar', 'world'}, 'oob'), expected_error);

function test_multiple_arrays

    mlunit_variation(@loc_assert_equals, [pi,pi;pi,pi], {pi,pi;pi,pi}, pi);

function test_explicit_parameters

    mlunit_variation(@loc_assert_equals, {{pi, pi}; {3, 3}});

function test_invalid_variation_lengths

    expected_error = struct();
    expected_error.identifier = 'MLUNIT:variationError';
    expected_error.message = 'Incompatible variation arguments. Argument number 2 provides 3 variations, but earlier arguments established 2 variations.';
    assert_error(@()mlunit_variation(@loc_assert_equals, [pi,pi], {pi,pi,pi}, pi), expected_error);

function test_explicit_input_combination

    % must produce 3 variations, all passing
    mlunit_variation(@loc_assert_equals, {1, 1, 1;NaN, 2, 2; 'foo', 'foo', 'foo'});

function test_input_different_orientation

    % must produce 2 variations, all passing
    mlunit_variation(@loc_assert_equals, [1 2], [1; 2]);

function test_explicit_input_combination_mismatch

    assert_error(@() mlunit_variation(@loc_assert_equals, [1 2 3], [1; 2]));
    assert_error(@() mlunit_variation(@loc_assert_equals, [1 2], [1; 2; 3]));

function test_assert_failure
    
    expected_error = struct();
    expected_error.identifier = 'MLUNIT:Failure';
    expected_error.message = mlunit_strjoin({...
        '- Variation {2, 3, 3} FAIL',...
        '    Data not equal:',...
        '      Expected : 2',...
        '      Actual   : 3',...
        '- Variation {3, 3, ''foo''} FAIL',...
        '    Data not equal:',...
        '      Expected : 3',...
        '      Actual   : ''foo''',...
        '- Variation {NaN, ''barb'', ''bar''} FAIL',...
        '    Data not equal:',...
        '      Expected : ''barb''',...
        '      Actual   : ''bar·''',...
        '      Changes  :     ^ ',...
              }, sprintf('\n'));
    assert_error(@()mlunit_variation(@loc_assert_equals, [1, 2, 3, NaN, 5], {1, 3, 3, 'barb', 5}, {1, 3, 'foo', 'bar', 5}), expected_error);

function test_nested_skip_test

    assert_error(@() mlunit_variation(@loc_skip_test_on_second_item, [1,2,3]), 'MLUNIT:Skipped');

function test_nested_skip_combination

    mlunit_variation(@loc_skip_combination_from_second, [1,2,3]);

function test_nested_skip_all_variations

    mlunit_param('all_variations_skip', true);
    assert_error(@() mlunit_variation(@loc_skip_combination_all, [1,2,3]), 'MLUNIT:Skipped');

function test_improper_call_skip_variation

    assert_error(@mlunit_skip_variation, 'MLUNIT:SkippedVariation');



%% Local helpers.
function loc_assert_foo(text)

    assert_equals('foo', text);
    
function loc_assert_equals(a1, a2, a3, varargin)

    % let a1=NaN circumvent this comparison
    if isnumeric(a1) && ~isnan(a1)
        assert_equals(a1, a2);
    end
    % only do another compare if possible
    if nargin >= 3
        assert_equals(a2, a3);
    end

function loc_skip_combination_from_second(item)

    if item >= 2
        mlunit_skip_variation('Second item is invalid.');
    end

function loc_skip_combination_all(item) %#ok<INUSD>

    mlunit_skip_variation('This item is invalid.');

function loc_skip_test_on_second_item(item)

    if item == 2
        mlunit_skip('Test skipped because the second item is invalid.');
    end
