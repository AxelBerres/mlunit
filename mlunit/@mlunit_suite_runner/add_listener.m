%Add a progress listener object to the list of subscribers.
%
%  Example:
%
%  >> sr = add_listener(mlunit_suite_runner, mlunit_progress_listener);
%  % This sets up an abstract base listener, which will throw errors
%  % when being executed.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = add_listener(self, listener)

mlunit_narginchk(2,2,nargin);
if ~isa(listener, 'mlunit_progress_listener'), error('listener need be mlunit_progress_listener'); end

% Maintain list of listeners as cell array, because R2007b would spit
% segmentation violations when using native array.
self.listeners{end+1} = listener;
