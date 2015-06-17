%Execute a single test suite
%  Implemented as class in order to manage progress listener subscriptions.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_suite_runner()

% default value, maintain listeners in cell array, see add_listener
self.listeners = {};

% create instance
self = class(self, 'mlunit_suite_runner');
