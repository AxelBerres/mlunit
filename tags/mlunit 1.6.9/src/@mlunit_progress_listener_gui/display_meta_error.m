%Display an error that occurred outside of any test execution.
%  We want to put any meta errors up on display in the GUI directly, as users
%  might miss console error dumps when working with the GUI.
%
%  SELF = display_meta_error(SELF, META) puts an error up for display, but does
%  not alter any test/error/failure count. META is an mlunit_errorinfo instance.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = display_meta_error(self, meta_error)

error(nargchk(2, 2, nargin, 'struct'));
if ~loc_iserror(meta_error), error('meta_error argument need be error struct'); end

% don't reset any current gui state; it might be helpful to know how many
% testcases executed before breakdown
errmsg = get_message_with_stack(mlunit_errorinfo(meta_error));
add_to_errorlist(self, 'ERROR', 'mlunit_gui', errmsg);
update_display(self);


function result = loc_iserror(type)

    result = isstruct(type) && ...
        numel(type) == 1 && ...
        all(isfield(type, {'identifier', 'message', 'stack'}));
