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
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: load_tests_from_test_case.m 267 2007-03-10 12:38:34Z thomi $

suite = [];
names = get_test_case_names(self, test_case_class);
if (length(names) > 0)
    suite = test_suite(map( ...
        test_case_class, ...
        names));
end;

%Return a list of objects instantiated from the class.
%test_case_class and the methods in test_names.
%
%  Example
%  =======
%  If you have for example a test_case my_test with two methods test_foo1
%  and test_foo2, then
%         map(test_loader, 'my_test', {'test_foo1' 'test_foo2'})
%  returns a list with two objects of my_tests, one instantiated with
%  test_foo1, the other with test_foo2.
%
%  See also TEST_LOADER/LOAD_TESTS_FROM_MFILE.
function tests = map(test_case_class, test_names) %#ok

tests = {};
for i = 1:length(test_names)
    test = eval([test_case_class, '(''', char(test_names(i)), ''')']);
    tests{i} = test;
end;
