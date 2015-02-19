%Execute a single test suite
%  Implemented as class in order to manage progress listener subscriptions.
%
%  Class Info / Example
%  ====================
%  The class gui_test_runner runs a test_case or test_suite and displays
%  results in a graphical user interface (using gui_test_result). 
%         Example: run(gui_test_runner);
%
%  See also GUI_TEST_RESULT.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

function self = mlunit_suite_runner()

% default value, maintain listeners in cell array, see add_listener
self.listeners = {};

% create instance
self = class(self, 'mlunit_suite_runner');
