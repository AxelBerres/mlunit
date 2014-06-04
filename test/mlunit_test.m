%mlunit_test executes mlunit_all_tests with the text_test_runner.
%
%  Example
%  =======
%         mlunit_test;

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: mlunit_test.m 150 2007-01-03 13:33:01Z thomi $

runner = text_test_runner(1, 1);
suite = mlunit_all_tests;
run(runner, suite);