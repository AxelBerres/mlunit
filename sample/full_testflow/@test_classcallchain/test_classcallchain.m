function t = test_classcallchain(name)

tc = test_case(name);
t = class(struct(), 'test_classcallchain', tc);

disp(['- test case load (' name ')']);
