function t = test_reflect(name)
%test_reflect tests the class mlunit_reflect.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_reflect');

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_reflect.m 42 2006-06-11 18:38:25Z thomi $

t.dummy = 0;
tc = test_case(name);
t = class(t, 'test_reflect', tc);