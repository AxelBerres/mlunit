function self = test_get_object(self)
%test_mlunit_gui/test_get_object tests the singleton object of
%mlunit_gui.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_get_object.m 162 2007-01-04 11:38:53Z thomi $

self.runner = run(self.runner, '', 0);
object = get_object(mlunit_gui(1));
assert_not_equals(0, get_handle(object));
assert_equals(get_handle(object), get_handle(self.runner));
