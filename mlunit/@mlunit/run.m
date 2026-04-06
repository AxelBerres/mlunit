function self = run(self, initial_test_object, dock)
%mlunit/run executes the the graphical user interface of mlUnit.
%  Alternatively, just use mlunit.
%
%  EXAMPLE
%  =======
%  Run in window mode:
%         run(mlunit);
%  Run in docked mode:
%         run(mlunit, 1);
%
%  See also MLUNIT, mlunit_gui/RUN.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: run.m 160 2007-01-03 21:56:21Z thomi $

if nargin >= 3
    run(mlunit_gui, initial_test_object, dock);
elseif nargin >= 2
    run(mlunit_gui, initial_test_object);
else
    run(mlunit_gui);
end
