%Console progress listener implementation.
%  Displays test results live on the console as they are being executed.
%
%  See init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_progress_listener_console()

mlunit_narginchk(0, 0, nargin);

self = struct();
self = class(self, 'mlunit_progress_listener_console', mlunit_progress_listener);
