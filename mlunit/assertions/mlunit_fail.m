%MLUNIT_FAIL Raise an error.
%  MLUNIT_FAIL(MSG, varargin) raises a MATLAB error. MSG is a string containing
%  the fail message. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin. MSG will only be sprintf-
%  evaluated if subsequent arguments are actually provided.
%
%  Examples
%     % raises a failure with a simple message
%     mlunit_fail('Test failed.');
%
%     % raises a failure with a sprintf message, expanded by a variable
%     mlunit_fail('Test failed, because 3 was not %d.', number);

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function mlunit_fail(msg, varargin)

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

% raise typed error, mask message string in order to prevent further sprintf expansion
error('MLUNIT:Failure', '%s', msg_string);
