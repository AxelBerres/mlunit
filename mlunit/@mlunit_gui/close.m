function self = close(self)
%mlunit_gui/close closes the graphical user interface of mlUnit.
%
%  Example
%  =======
%         run(mlunit_gui, 'mlunit_all_tests');
%         close(mlunit_gui);
%
%  See also mlunit_gui.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: close.m 158 2007-01-03 20:25:39Z thomi $

object = get_object(self);
if (~isempty(object) && (strcmp('mlunit_gui', class(object))))
    handle = get_handle(object);
    if (~isempty(handle))
        close(handle);
    end;
end;