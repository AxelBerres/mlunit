function self = test_failed_set_up(self)
%test_test_case/test_failed_set_up tests the behaviour of test_case/run, if
%the set_up method fails.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_test_case(''test_failed_set_up'');');
%
%  See also TEST_CASE/RUN.

%  �Author: Thomas Dohmke <thomas@dohmke.de> �
%  $Id: test_failed_set_up.m 44 2006-06-11 18:54:09Z thomi $

test = mock_test_failed_set_up('test_method');
[result, dummy, test] = run_test(mlunit_suite_runner, test);
assert_equals('tear_down ', get_log(test));
