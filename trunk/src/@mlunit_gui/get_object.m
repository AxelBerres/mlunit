function self = get_object(self) %#ok
%mlunit_gui/get_object returns the singleton object of the gui window.
%
%  Example
%  =======
%         run(mlunit_gui, 'mlunit_all_tests');
%         runner = get_object(mlunit_gui)
%
%  See also mlunit_gui.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: get_object.m 158 2007-01-03 20:25:39Z thomi $

shh = builtin('get', 0, 'ShowHiddenHandles');
set(0, 'ShowHiddenHandles', 'on');
handle = findall(0, 'Name', 'mlUnit');
self = builtin('get', handle, 'UserData');
set(0, 'ShowHiddenHandles', shh);
