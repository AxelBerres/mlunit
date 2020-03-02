%Return whether this error represents a failure rather than a common error.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function result = is_skipped(self)

result = strcmp(self.err.identifier, 'MLUNIT:Skipped');
