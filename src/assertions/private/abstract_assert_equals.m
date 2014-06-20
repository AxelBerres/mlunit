function abstract_assert_equals(pass_if_equal, expected, actual, absolute_eps_or_msg, varargin)
%ABSTRACT_ASSERT_EQUALS Raise an error if two expressions do not compare.
%  ABSTRACT_ASSERT_EQUALS(PASS_IF_EQUAL, EXPECTED, ACTUAL)
%  raises a MATLAB error if PASS_IF_EQUALS is true and EXPECTED and ACTUAL
%  are not the same. Also raises a MATLAB error if PASS_IF_EQUALS is false
%  and EXPECTED and ACTUAL are the same.
%
%  ABSTRACT_ASSERT_EQUALS(PASS_IF_EQUAL, EXPECTED, ACTUAL, ...
%  ABSOLUTE_ESP) does the same, except if EXPECTED and ACTUAL are numeric
%  and of the same type. Then they are considered equal, if their absolute
%  difference is smaller or equal to ABSOLUTE_EPS. This works for any
%  numerics, but is incompatible with equal NaN handling.
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
%  $Id$

if nargin < 3, error('Not enough input arguments.'); end
if ~islogical(pass_if_equal), error('pass_if_equal must be a logical'); end

equal_nans = mlunit_param('equal_nans');

% default values for msg and eps
absolute_eps = 0;
msg = sprintf('Expected %s actually was %s.', printable(expected), printable(actual));

% Fourth argument can either be absolute_eps or msg. Handle input args carefully.
if nargin >= 4 && isnumeric(absolute_eps_or_msg)
   absolute_eps = absolute_eps_or_msg;
   msg = [msg sprintf(' Tolerance was %s.', printable(absolute_eps))];
   % if fourth argument is eps, then the fifth may be the msg and all others the
   % msg sprintf arguments
   if nargin >= 5
      msg = sprintf(varargin{1}, varargin{2:end});
   end
   
elseif nargin >= 4 && ischar(absolute_eps_or_msg)
   msg = sprintf(absolute_eps_or_msg, varargin{:});
end

% only check against eps if expected and actual both are numeric and have the
% same type, else MATLAB complains about incompatible types when using
% subtraction during eps checking later on
are_compatible_numerics = isnumeric(expected) && isequal(class(expected), class(actual));

% determine equality
if are_compatible_numerics
   
   % compare all values by default
   indices = logical(ones(size(expected)));
   if equal_nans
      % select only indices for comparison where not both expected and actual
      % are NaN
      indices = ~(isnan(expected) & isnan(actual));
   end

   % Build matrix of expected/actual differences. If at one position expected or
   % actual have a NaN, that position's difference will be NaN and fail the eps
   % test, as it should. If at one position both have a NaN, then they will have
   % been filtered before if NaNs are to be treated equal, or their difference
   % will yield a NaN as well if NaNs are to be treated different. If both have
   % an actual value other than NaN, their difference will be compared with eps
   % for real.
   diffs = expected(indices) - actual(indices);
   
   % all absolute differences must be smaller than or equal to eps
   equals = all(abs(diffs) <= absolute_eps);

% all non-numeric types, or mixed types are checked by isequal.
elseif equal_nans
   equals = isequalwithequalnans(actual, expected);
else
   equals = isequal(actual, expected);
end

% fail if pass on equal requested, but is not equal
% fail if fail on equal requested, and is equal
% else, pass quietly
if xor(pass_if_equal, equals)
   mlunit_fail(msg);
end
