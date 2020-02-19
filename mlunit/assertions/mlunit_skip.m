%MLUNIT_SKIP Skip a test at runtime.
%  MLUNIT_SKIP(MSG, varargin) breaks off the current test and marks it as skipped.
%  tear_down for this test still executes.
%  MSG is a string containing a message (optional).
%  MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin. MSG will only be sprintf-
%  evaluated if subsequent arguments are actually provided.
%
%  Examples
%     % skips with a simple message
%     mlunit_skip('Test skipped.');
%
%     % skips with a sprintf message, expanded by a variable
%     mlunit_skip('Test skipped, because %s was not installed.', 'some tool');

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function mlunit_skip(msg, varargin)

% set empty message if left empty, take msg, or interpret sprintf arguments
switch nargin
case 0
   msg_string = '';
case 1
   msg_string = msg;
otherwise
   % avoid multiple sprintf calls on msg later on, in case msg contains masked
   % sprintf control sequences that should not be interpreted
   msg_string = sprintf(msg, varargin{:});
end

if isempty(msg_string)
    msg_string = 'Test skipped during execution.';
end

% raise typed error, mask message string in order to prevent further sprintf expansion
error('MLUNIT:Skipped', '%s', msg_string);
