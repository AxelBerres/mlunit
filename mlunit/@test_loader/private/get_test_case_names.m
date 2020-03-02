function names = get_test_case_names(self, test_case_class) %#ok
%test_loader/get_test_case_names returns a list of string with all
%test* methods from the test_case_class.
%
%  Example
%  =======
%  get_test_case_names is usually called from
%  test_loader/load_tests_from_mfile:
%         names = get_test_case_names(self, test_case_class);
%
%  See also TEST_LOADER/LOAD_TESTS_FROM_MFILE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

names = loc_get_methods(test_case_class);
for i = size(names, 1):-1:1
    if (~strncmp(names(i), 'test', 4))
        names(i) = [];
    end;
end;
names = sortrows(names);

% check that we actually got instances of test_case
% this lets the test case constructor execute once more
if ~isempty(names)
    t = eval([test_case_class, '(''', char(names(1)), ''')']);
    if (~isa(t, 'test_case'))
        error('MLUNIT:invalidTestObject', 'Found at least one test method, but its object does not inherit from test_case, as it should.');
    end
end


% get methods for a class object or class name
% also get inherited methods, but this works for class name arguments only,
% if the class has been instantiated at least once, and is known in memory
function meths = loc_get_methods(class_name)

    meths = methods(class_name, '-full');
    % enforce cell array, even if empty
    if isempty(meths), meths = {}; end
    % delete constructor method
    meths(strcmp(class_name, meths)) = [];
