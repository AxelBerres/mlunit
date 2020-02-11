function self = test_catch_output(self)
%test_test_case/test_catch_output tests the behaviour of test_case/run, when
%'catch_output' has been activated

mlunit_param('catch_output', true);
mlunit_param('mark_testphase', true);

test = mock_test_catch_output('test_method');
[result, dummy, test] = run_test(mlunit_suite_runner, test);

assert_not_empty(result.console);

% releases earlier than R2012b use {}, R2012b and later use []
if verLessThan('matlab', '8.0')
    warning_start_marker = ['{' char(8)];
    warning_close_marker = ['}' char(8)];
else
    warning_start_marker = ['[' char(8)];
    warning_close_marker = [']' char(8)];
end

expected_output_front = sprintf([...
    '[setup] Mock test set up fixture\n' ...
    '[test]  Mock test body\n' ...
    '[test]  %sWarning: Mock test warning%s \n' ...
    '[test]  %s> In' ...
    ], warning_start_marker, warning_close_marker, warning_start_marker);
len = numel(expected_output_front);
assert_equals(expected_output_front, result.console(1:len));

expected_output_back = sprintf([...
    '[test]  Mock test body end\n' ...
    '[tdown] Mock test tear down fixture\n' ...
    ]);
len = numel(expected_output_back);
assert_equals(expected_output_back, result.console(end-(len-1):end));
