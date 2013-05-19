function self = test_unbalanced_parentheses(self) %#ok
%mock_test/test_method is a mock test method that has a unbalanced
%parentheses error.
%
%  Example
%  =======
%         run(gui_test_runner, 'mock_test(''test_unbalanced_parentheses'');');
%
%  See also MOCK_TEST, TEST_TEST_RESULT.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_unbalanced_parentheses.m 272 2007-04-06 15:01:03Z thomi $

assert_equals(0, 1)); %#ok