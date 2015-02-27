function s = str(self)
%mlunit_gui/str return a string with the class name.
%
%  Example
%  =======
%  For the class mlunit_gui, str will always return:
%           mlunit_gui
%
%  See also TEST_CASE/STR.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: str.m 155 2007-01-03 20:01:35Z thomi $

s = class(self);