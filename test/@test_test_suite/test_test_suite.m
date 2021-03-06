function t = test_test_suite(name)
%test_test_suite tests the class test_suite.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_test_suite');
%
%  See also TEST_SUITE.

%  �Author: Thomas Dohmke <thomas@dohmke.de> �
%  $Id: test_test_suite.m 47 2006-06-11 19:26:32Z thomi $

tc = test_case(name);
t = class(struct(), 'test_test_suite', tc);
