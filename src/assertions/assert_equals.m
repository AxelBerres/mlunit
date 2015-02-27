function assert_equals(expected, actual, varargin)
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
%  See also  MLUNIT_FAIL, ASSERT_NOT_EQUALS, EPS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: assert_equals.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 2,
   error('assert_equals: Not enough input arguments.');
end

abstract_assert_equals(true, expected, actual, varargin{:});
