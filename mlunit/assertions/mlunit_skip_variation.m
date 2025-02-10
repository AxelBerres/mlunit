%MLUNIT_SKIP_VARIATION Skip only a variation at runtime, continuing the test.
%  MLUNIT_SKIP_VARIATION(MSG, varargin) breaks off the current variation and marks it as skipped.
%  The rest of the test, and tear_down for this test still execute.
%  Must be called from within a call to mlunit_variation. If not, mlUnit will
%  report an error instead.
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
%
%  See also  MLUNIT_SKIP, MLUNIT_VARIATION

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function mlunit_skip_variation(msg, varargin)

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
    msg_string = 'Variation skipped during execution.';
end

% raise typed error, mask message string in order to prevent further sprintf expansion
error('MLUNIT:SkippedVariation', '%s', msg_string);
