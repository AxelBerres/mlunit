%Console progress listener implementation.
%  Displays test results live in the GUI as they are being executed.
%  Is instanciated with handles of the graphical GUI objects it needs to update.
%  Also stores internal states, e.g. how many tests have been run so far. You
%  therefore are advised to keep the instance variable around and up to date.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_progress_listener_console()

error(nargchk(0, 0, nargin, 'struct'));

self = struct();
self = class(self, 'mlunit_progress_listener_console', mlunit_progress_listener);
