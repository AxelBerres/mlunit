function self = test_add_error_with_stack(self)
%test_test_case/test_result_list tests the method
%test_result/add_error_with_stack.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_test_result(''test_add_error_with_stack'');');
%
%  See also TEST_RESULT/ADD_ERROR_WITH_STACK.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_add_error_with_stack.m 269 2007-04-02 19:54:39Z thomi $

test = mock_test('test_unbalanced_parentheses');
[result, test] = run_test(mlunit_suite_runner, test);
assert_equals('set_up tear_down ', get_log(test));

assert_equals(1, numel(result));
assert_equals(1, numel(result.errors));

% the actual error message differs across the MATLAB releases
releases_errmsgs = {...
    'Unbalanced or misused parentheses or brackets.', ...
    'Unbalanced or unexpected parenthesis or bracket.'};
assert_true(ismember(filter_lasterror_wraps(result.errors{1}), releases_errmsgs));

stack_lines = strread(get_message_with_stack(result.errors{1}), '%s', 'delimiter', '\n');
assert_false(isempty(findstr('test_unbalanced_parentheses.m at line', char(stack_lines(2)))));
assert_false(isempty(findstr('run_test.m at line', char(stack_lines(3)))));
