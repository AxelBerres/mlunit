function self = test_mlunit_gui(name)
%test_mlunit_gui tests the class mlunit_gui.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_mlunit_gui.m 162 2007-01-04 11:38:53Z thomi $

self.runner = [];
tc = test_case(name);
self = class(self, 'test_mlunit_gui', tc);
