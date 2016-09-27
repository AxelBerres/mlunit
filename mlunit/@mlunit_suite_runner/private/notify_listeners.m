%Notify progress listeners.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = notify_listeners(self, function_name, varargin)

mlunit_narginchk(2,Inf,nargin);
if ~ischar(function_name), error('function_name need be char'); end

% inform progress listeners of impending test updates; keep self updated
for lidx=1:numel(self.listeners)
    self.listeners{lidx} = feval(function_name, self.listeners{lidx}, varargin{:});
end
