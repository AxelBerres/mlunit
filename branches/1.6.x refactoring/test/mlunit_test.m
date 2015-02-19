%mlunit_test executes mlunit_all_tests with the text_test_runner.
%
%  Example
%  =======
%         mlunit_test;

%  $Id: mlunit_test.m 150 2007-01-03 13:33:01Z thomi $

recursive_test_run(fileparts(mfilename('fullpath')));
