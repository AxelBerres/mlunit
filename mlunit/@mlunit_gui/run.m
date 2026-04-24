function self = run(self, test, dock)
%mlunit_gui/run is an alternative method to execute the graphical 
%user interface of mlUnit. 
%
%  Example
%  =======
%  With the second parameter it is possible to specify a test method, test
%  case or test suite, that is executed immediately after the start of the
%  graphical user interface. 
%         Example: run(mlunit_gui, 'mlunit_all_tests');
%
%  See also GUI_TEST_RESULT, mlunit_gui.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: run.m 166 2007-01-04 21:19:31Z thomi $

[recent_test, recent_dock, recent_shorten] = mlunit_load_mru_file();

if nargin < 3 || isempty(dock), dock = recent_dock; end
if nargin < 2 || isempty(test)
    test = recent_test;
    jumpstart = false;
else
    jumpstart = true;
end

self.jumpstart = jumpstart;
self.initial_test_case = test;
self.dock = dock;
self.shorten = recent_shorten;
self.callback = 0;

% start gui
gui(self);

% collect actual handle from the gui_openingfcn callback
self.handle = get_handle(get_object(self));
