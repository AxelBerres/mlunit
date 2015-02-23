function self = tear_down(self)
%test_mlunit_gui/set_up tears down the fixture for
%test_mlunit_gui.
%
%  Example
%  =======
%         run(text_test_runner, 'test_mlunit_gui');

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: tear_down.m 162 2007-01-04 11:38:53Z thomi $

close(self.runner);