function abstract_assert_equals(equal_nans, pass_if_equal, expected, actual, absolute_eps_or_msg, varargin)
%ABSTRACT_ASSERT_EQUALS Raise an error if two expressions do not compare.
%  ABSTRACT_ASSERT_EQUALS(EQUAL_NANS, PASS_IF_EQUAL, EXPECTED, ACTUAL)
%  raises a MATLAB error if PASS_IF_EQUALS is true and EXPECTED and ACTUAL
%  are not the same. Also raises a MATLAB error if PASS_IF_EQUALS is false
%  and EXPECTED and ACTUAL are the same.
%  If EQUAL_NANS is false, compare using isequal, if EQUAL_NANS is true,
%  compare using isequalwithequalnans.
%
%  ABSTRACT_ASSERT_EQUALS(EQUAL_NANS, PASS_IF_EQUAL, EXPECTED, ACTUAL, ...
%  ABSOLUTE_ESP) does the same, except if EXPECTED and ACTUAL are numeric
%  and of the same type. Then they are considered equal, if their absolute
%  difference is smaller or equal to ABSOLUTE_EPS. This works for any
%  numerics, but is incompatible with equal NaN handling. If EQUAL_NANS is
%  true, eps checking will only occur when all elements of EXPECTED and
%  ACTUAL are finite (not NaN and not Inf), else eps checking will be
%  omitted and isequalwithequalnans used instead.
%  
%  ABSTRACT_ASSERT_EQUALS(..., MSG, varargin) does the same, but with
%  the custom error message MSG. MSG may contain sprintf arguments, which
%  can be expanded by subsequent arguments in varargin.
%
%  See also  ASSERT_EQUALS, ASSERT_NOT_EQUALS, ASSERT_EQUALS_WITHEQUALNANS,
%  ASSERT_NOT_EQUALS_WITHEQUALNANS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert_equals.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 4, error('Not enough input arguments.'); end
if ~islogical(equal_nans), error('equal_nans must be a logical'); end
if ~islogical(pass_if_equal), error('pass_if_equal must be a logical'); end

% default values for msg and eps
absolute_eps = 0;
msg = sprintf('Expected <%s>, but was <%s>.', to_string(expected), to_string(actual));
msg_args = {};

% Fourth argument can either be absolute_eps or msg. Handle input args carefully.
if nargin >= 5 && isnumeric(absolute_eps_or_msg)
   absolute_eps = absolute_eps_or_msg;
   msg = [msg sprintf(' Tolerance was <%s>.', to_string(absolute_eps))];
   % if third argument is eps, then the fourth may be the msg and all others the
   % msg sprintf arguments
   if nargin >= 6
      msg = varargin{1};
      msg_args = varargin(2:end);
   end
   
elseif nargin >= 5 && ischar(absolute_eps_or_msg)
   msg = absolute_eps_or_msg;
   msg_args = varargin;
end

are_compatible_numerics = isnumeric(expected) && isequal(class(expected), class(actual));
check_eps_with_nans = ~equal_nans || (isfinite(expected) && isfinite(actual));

% determine equality
if are_compatible_numerics && check_eps_with_nans
   % only check against eps if expected and actual both are numeric and have
   % the same type, else MATLAB complains about incompatible types used for
   % subtraction.
   % Be prepared for vectors and matrixes coming in expected and actual.
   equals = all(abs(expected - actual) <= absolute_eps);
% all non-numeric types, or mixed types, or variables containing NaNs if
% NaNs are to be treated equal are checked by isequal.
elseif equal_nans
   equals = isequalwithequalnans(actual, expected);
else
   equals = isequal(actual, expected);
end

% fail if pass on equal requested, but is not equal
% fail if fail on equal requested, and is equal
% else, pass quietly
if xor(pass_if_equal, equals)
   % delay msg_args expansion until now, to only expand them in case of failure
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
