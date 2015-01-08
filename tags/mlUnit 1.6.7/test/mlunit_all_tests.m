function suite = mlunit_all_tests
%mlunit_all_tests creates a test_suite with all test for mlunit.
%
%  Example
%  =======
%         run(gui_test_runner, 'mlunit_all_tests');

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: mlunit_all_tests.m 150 2007-01-03 13:33:01Z thomi $

suite = test_suite;
loader = test_loader;
suite = set_name(suite, 'mlunit_all_tests');
suite = add_test(suite, load_tests_from_test_case(loader, 'test_function_test_case'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_reflect'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_test_case'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_test_result'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_test_suite'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_test_loader'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_text_test_runner'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_text_test_result'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_gui_test_runner'));
suite = add_test(suite, test_assert_equals);
suite = add_test(suite, test_assert_equals_struct);
suite = add_test(suite, test_assert_equals_withequalnans);
suite = add_test(suite, test_assert_error);
suite = add_test(suite, test_assert_matfile_equalsShould);
suite = add_test(suite, test_assert_not_equals);
suite = add_test(suite, test_assert_warning);
suite = add_test(suite, test_fail);
suite = add_test(suite, test_pass);
suite = add_test(suite, test_find_struct_differences);
suite = add_test(suite, test_strjoin);
