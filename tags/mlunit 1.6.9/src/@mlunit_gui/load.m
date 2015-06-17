function load(self) %#ok
%mlunit_gui/loads starts the graphical user interface of mlUnit with
%saved parameters from the .mat-file mlunit.tmp.
%
%  Example
%  =======
%         load(mlunit_gui);
%
%  See also mlunit_gui, mlunit_gui/SAVE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: load.m 166 2007-01-04 21:19:31Z thomi $

try
    saved = load('mlunit.tmp', '-mat');
    run(mlunit_gui, '', saved.dock, saved.shorten);
    object = get_object(mlunit_gui);
    set(object.handles.gui_test_case, 'String', saved.test_case_name);
    delete('mlunit.tmp');
catch
end;

