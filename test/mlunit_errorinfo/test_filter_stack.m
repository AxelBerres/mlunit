%Test filter_stack functionality.
%
%  See filter_stack

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function test = test_filter_stack %#ok<STOUT>

output_tests_from_mfile;
    

function test_empty_stack

    assert_equals(loc_empty_stack, loc_filter(loc_empty_stack));
    
function test_default_stack

    fs = loc_filter(loc_sample_stack);
    
    assert_equals(1, numel(fs));
    assert_true(all(isfield(fs, {'file', 'name', 'line'})));
    assert_equals('test_that', fs(1).name);

function test_no_change

    stack = struct(...
        'file', 'C:\mlunit\test\junit_provocation\test_junit_error.m', ...
        'name', 'test_that', ...
        'line', 15);
    
    assert_equals(stack, loc_filter(stack));


% return the filtered given stack or the filtered default stack
function filtered_stack = loc_filter(stack)

    % dummy errorinfo instance
    errstruct = struct();
    errstruct.message = '';
    errorinfo = mlunit_errorinfo(errstruct);
    
    filtered_stack = filter_failure_stack(errorinfo, stack);

% construct a lasterror stack structure with sample items stemming from a
% failure
function stack = loc_sample_stack()

    stackinfos = { ...
        'C:\mlunit\src\assertions\mlunit_fail.m',                 'mlunit_fail',           34; ...
        'C:\mlunit\src\assertions\assert_true.m',                 'assert_true',           30; ...
        'C:\mlunit\test\junit_provocation\test_junit_error.m',    'test_that',             15; ...
        'C:\mlunit\src\@function_test_case\run_test.m',           'run_test',              21; ...
        'C:\mlunit\src\@mlunit_suite_runner\run_test.m',          'run_test',              50; ...
        'C:\mlunit\src\@mlunit_suite_runner\run_suite.m',         'run_suite',             62; ...
        'C:\mlunit\src\automation\recursive_test_run.m',          'runTestsuite',          73; ...
        'C:\mlunit\src\automation\recursive_test_run.m',          'recursive_test_run',    36; ...
    };

    stack = struct(...
        'file', stackinfos(:,1), ...
        'name', stackinfos(:,2), ...
        'line', stackinfos(:,3));

function stack = loc_empty_stack()

    stack = struct(...
        'file', {}, ...
        'name', {}, ...
        'line', {});
