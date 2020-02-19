%Set an error's additional cause field.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function self = set_additional_cause(self, additional_cause)

if nargin >= 2 && ischar(additional_cause)
    self.additional_cause = additional_cause;
end
