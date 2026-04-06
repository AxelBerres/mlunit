function self = mlunit(initial_test_object)
%mlunit initialization.
%  Run the graphical user interface of mlUnit.
%  Or, create an object of the class mlunit, but that doesn't mean anything right now.
%
%  Class Info / Example
%  ====================
%  The class mlunit is a shortcut to run the graphical user interface of
%  mlUnit.
%
%  Just start mlUnit:
%       mlunit;
%  Run a specific test right away:
%       mlunit('test_test_case');
%  Just start mlUnit, but the old way.
%
%  See also mlunit_gui.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  Author: Thomas Dohmke <thomas@dohmke.de>

self = class(struct([]), 'mlunit');

% Run immediately if mlunit is being called as a shortcut.
if nargout == 0
    if nargin >= 2
        run(self, initial_test_object, docked);
    elseif nargin >= 1
        run(self, initial_test_object);
    else
        run(self);
    end
end
