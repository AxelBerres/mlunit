function assert_not_equals(expected, actual, varargin)
%ASSERT_NOT_EQUALS Raise an error if two expressions evaluate to the same.
%  ASSERT_NOT_EQUALS(EXPECTED, ACTUAL) raises a MATLAB error if EXPECTED
%  and ACTUAL are the same. If EXPECTED and ACTUAL are numeric, they both
%  have to be the very same number, down to the current platform's
%  int or floating-point accuracy.
%
%  ASSERT_NOT_EQUALS(EXPECTED, ACTUAL, MSG, varargin) does the same, but
%  with the custom error message MSG. MSG may contain sprintf arguments,
%  which can be expanded by subsequent arguments in varargin.
%
%  ASSERT_NOT_EQUALS(EXPECTED, ACTUAL, ABSOLUTE_EPS) and
%  ASSERT_NOT_EQUALS(EXPECTED, ACTUAL, ABSOLUTE_EPS, MSG, varargin) do the same,
%  except if EXPECTED and ACTUAL are numeric. Then they are considered equal,
%  if their absolute difference is smaller or equal to ABSOLUTE_EPS. This works
%  for any numerics.
%
%  Examples
%     % asserts string variable output being not 'no'
%     assert_not_equals(output, 'no');
%
%     % asserts variable arg being not 0; specifies a custom message
%     assert_not_equals(arg, 0, 'Input argument is %d, but should not.', 0);
%
%  See also  MLUNIT_FAIL, ASSERT_EQUALS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert_not_equals.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 2
   error('assert_not_equals: Not enough input arguments.');
end

abstract_assert_equals(false, expected, actual, varargin{:});
