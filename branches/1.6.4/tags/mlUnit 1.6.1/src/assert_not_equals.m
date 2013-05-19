function assert_not_equals(expected, actual, msg, varargin)
%ASSERT_NOT_EQUALS Raise an error if two expressions evaluate to the same.
%  ASSERT_NOT_EQUALS(EXPECTED, ACTUAL) raises a MATLAB error if EXPECTED
%  and ACTUAL are the same.
%
%  ASSERT_NOT_EQUALS(EXPECTED, ACTUAL, MSG, varargin) does the same, but
%  with the custom error message MSG. MSG may contain sprintf arguments,
%  which can be expanded by subsequent arguments in varargin.
%
%  Examples
%     % asserts string variable output being not 'no'
%     assert_not_equals(output, 'no');
%
%     % asserts variable arg being not 0; specifies a custom message
%     assert_not_equals(arg, 0, 'Input argument is %d, but should not.', 0);
%
%  See also  FAIL, ASSERT_EQUALS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert_not_equals.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 2
   fail('assert_not_equals: Not enough input arguments.');
end

if nargin < 3 || isempty(msg)
   msg = sprintf('Expected same <%s> was not <%s>.', to_string(expected), to_string(actual));
end

if isequal(actual, expected)
   fail(msg, varargin{:});
end


%% subfunction to_string
function outstring = to_string(input)

   if ischar(input)
      outstring = input;
   elseif isnumeric(input) || islogical(input)
      outstring = num2str(input);
   elseif isstruct(input)
      outstring = 'MATLAB structure array';
   elseif iscell(input)
      outstring = 'MATLAB cell array';
   else
      outstring = 'unrecognized type';
   end
