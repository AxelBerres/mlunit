function assert_equals(expected, actual, absolute_eps_or_msg, varargin)
%ASSERT_EQUALS Raise an error if two expressions differ.
%  ASSERT_EQUALS(EXPECTED, ACTUAL) raises a MATLAB error if EXPECTED
%  and ACTUAL are not the same. If EXPECTED and ACTUAL are numeric, they both
%  have to be the very same number, down to the current platform's
%  int or floating-point accuracy.
%
%  ASSERT_EQUALS(EXPECTED, ACTUAL, MSG, varargin) does the same, but with
%  the custom error message MSG. MSG may contain sprintf arguments, which
%  can be expanded by subsequent arguments in varargin.
%
%  ASSERT_EQUALS(EXPECTED, ACTUAL, ABSOLUTE_EPS) and
%  ASSERT_EQUALS(EXPECTED, ACTUAL, ABSOLUTE_EPS, MSG, varargin) do the same,
%  except if EXPECTED and ACTUAL are numeric. Then they are considered equal,
%  if their absolute difference is smaller or equal to ABSOLUTE_EPS. This works
%  for any numerics.
%
%  Examples
%     % asserts string variable output being 'yes'
%     assert_equals(output, 'yes');
%
%     % asserts variable arg being 3; specifies a custom message
%     assert_equals(arg, 3, 'Input argument is not %d.', 3);
%
%     % asserts that 0.1+0.2 equals 0.3, within eps(0.3) tolerance
%     assert_equals(0.1+0.2, 0.3, eps(0.3));
%
%     % asserts that 101 equals 100, within tolerance of 5
%     assert_equals(101, 106, 5);
%
%  See also  FAIL, ASSERT_NOT_EQUALS, EPS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert_equals.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 2,
   fail('assert_equals: Not enough input arguments.');
end

% default values for msg and eps
absolute_eps = 0;
msg = sprintf('Expected <%s>, but was <%s>.', to_string(expected), to_string(actual));
msg_args = {};

% Third argument can either be absolute_eps or msg. Handle input args carefully.
if nargin >= 3 && isnumeric(absolute_eps_or_msg)
   absolute_eps = absolute_eps_or_msg;
   msg = [msg sprintf(' Tolerance was <%s>.', to_string(absolute_eps))];
   % if third argument is eps, then the fourth may be the msg and all others the
   % msg sprintf arguments
   if nargin >= 4
      msg = varargin{1};
      msg_args = varargin(2:end);
   end
   
elseif nargin >= 3 && ischar(absolute_eps_or_msg)
   msg = absolute_eps_or_msg;
   msg_args = varargin;
end

% determine equality
if isnumeric(expected) && isnumeric(actual)
    % only check against eps if expected and actual both are numeric
    if abs(expected - actual) > absolute_eps
        fail(msg, msg_args{:});
    end
% all non-numeric types or mixed numerics, non-numerics are checked by isequal
elseif ~isequal(actual, expected),
    fail(msg, msg_args{:});
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
