function self = set_up(self)
%test_mlunit_gui/set_up sets up the fixture for test_mlunit_gui.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: set_up.m 162 2007-01-04 11:38:53Z thomi $

currentstack = dbstack;
if any(strcmp({currentstack.name}, 'gui_run_callback'))
    mlunit_skip('Can''t test the mlUnit GUI while running from the mlUnit GUI.');
end

self.runner = mlunit_gui;
