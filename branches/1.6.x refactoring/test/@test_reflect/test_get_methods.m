function self = test_get_methods(self)
%test_reflext/test_get_methods tests the method test_reflect/get_methods.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_reflect(''test_get_methods'')');
%
%  See also REFLECT/GET_METHODS.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_get_methods.m 47 2006-06-11 19:26:32Z thomi $

r = reflect('test_case');
m = get_methods(r);
assert_true(size(m, 1) > 0);
assert_true(~any(strcmp(m, 'test_case')));
assert_ismember('get_name', m);
assert_ismember('set_up', m);
assert_ismember('tear_down', m);

function assert_ismember(element, collection)

    assert_equals(1, sum(strcmp(collection, element)));
