%Return the test's disabled state.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function [disabled, reason] = get_disabled(self)

disabled = self.disabled;
reason = self.disabled_reason;
