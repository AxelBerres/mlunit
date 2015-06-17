%MLUNIT_FAIL_WITH_REASON Raise an error with a specific reason message.
%  MLUNIT_FAIL_WITHT_REASON(REASON, MSG, varargin) raises a MATLAB error.
%  REASON is a string containing a message part, MSG is another such string.
%  Both will be concatenated, if need be separated by a newline.
%  Subsequent varargin arguments will be sprintf evaluated in relation to
%  MSG.
%
%  Examples
%     % raises a failure with a simple message
%     mlunit_fail_with_reason('Values didn't match.', 'Test failed.');
%
%     % raises a failure with a sprintf message, expanded by a variable
%     mlunit_fail('Because someone was being silly.', 'Test %s failed.', name);

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function mlunit_fail_with_reason(reason, custom_msg, varargin)

if nargin == 0
    reason = '';
end

if nargin <= 1
    custom_msg = '';
end

if nargin >= 2
   % avoid multiple sprintf calls later on, in case custom_msg contains masked
   % sprintf control sequences that should not be interpreted
    custom_msg = sprintf(custom_msg, varargin{:});
end

% put reason and custom_msg together; add newline if both non-empty
if isempty(reason) || isempty(custom_msg)
    msg_string = [custom_msg reason];
else
    msg_string = sprintf('%s\n%s', custom_msg, reason);
end

% raise typed error, mask message string in order to prevent further sprintf expansion
error('MLUNIT:Failure', '%s', msg_string);
