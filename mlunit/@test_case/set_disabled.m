%Set the test's disabled state.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = set_disabled(self, reason)

if nargin < 2
   reason = '';
end

self.disabled = true;
self.disabled_reason = reason;
