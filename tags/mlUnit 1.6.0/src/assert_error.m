function assert_error(exprstring, expected_msg)
%ASSERT_ERROR Raise an error if evaluation of expression does not throw an
%error.
%  ASSERT_ERROR(EXPRSTRING) evaluates the string EXPRING and raises a
%  MATLAB error if the evaluation did not raise an error itself. Use it to
%  assert that a certain expression definitely raises an error.
%
%  ASSERT_ERROR(EXPRSTRING, EXPECTED_MSG) does the same, but also asserts
%  that the error message equals EXPECTED_MSG.
%
%  Examples
%     % asserts variable arg being empty
%     assert_error('error');
%
%     % the same, with message check
%     assert_error('error(''huh\nha'');', 'huh\nha');
%
%  See also  ISEMPTY, FAIL, ASSERT

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 1 || isempty(exprstring), exprstring = ''; end

bCaught = false;
try
   eval(exprstring);
catch
   bCaught = true;
   err = lasterror;
   % Eat first line that should read 'Error using ==> assert_error'. The actual
   % message comes after it.
   actual_msg = strrep(err.message, sprintf('Error using ==> assert_error\n'), '');
   if nargin < 2 || strcmp(actual_msg, expected_msg)
      bMsgMatches = true;
   else
      bMsgMatches = false;
   end
end

if ~bCaught
   fail('Expected error, but none ocurred.');
elseif ~bMsgMatches
   % don't use sprintf %s expansion here, in order to preserve special
   % characters in the strings
   fail(['Expected message ''' expected_msg ''' but was ''' actual_msg '''']);
end
