function suite = load_tests_from_test_case(self, test_case_class)
%test_loader/load_tests_from_test_case returns a test_suite with all
%test* methods from a test_case.
%  It returns an empty matrix, if the test is not found.
%
%  Example
%  =======
%         loader = test_loader;
%         suite = test_suite(load_tests_from_test_case(loader, 'my_test'));


%  This Software and all associated files are released unter the
%  GNU General Public License (GPL), see LICENSE for details.
%
%  $Id: load_tests_from_test_case.m 267 2007-03-10 12:38:34Z thomi $

suite = mlunit_testsuite;
suite = set_name(suite, test_case_class);
names = get_test_case_names(self, test_case_class);

for i = 1:length(names)
    % instanciate test
    testobj = eval([test_case_class, '(''', char(names(i)), ''')']);
    
    % add to suite
    suite = add_test(suite, testobj);
end;
