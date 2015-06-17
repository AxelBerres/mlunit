function assert_true(expr, varargin)
%ASSERT_TRUE Raise an error if expression does not evaluate to true.
%  ASSERT_TRUE(EXPR) evaluates EXPR and raises a MATLAB error if it does
%  not yield MATLAB's notion of true, i.e. logical 1 or numericals > 0.
%
%  ASSERT_TRUE(EXPR, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_TRUE() just passes.
%
%  ASSERT_TRUE could also have been named ASSERT. But from MATLAB R2007b onward,
%  this collides with MATLAB's built-in assert.
%
%  Examples
%     % asserts string variable arg being empty
%     assert_true(isempty(arg));
%
%     % asserts variable arg being a cell array; specifies a custom message
%     assert_true(iscell(arg), 'Input argument is no cell array');
%
%  See also  MLUNIT_FAIL, ASSERT_FALSE

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: assert_true.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin >= 1 && ~expr
    reason = 'Expected true was actually false.';
    mlunit_fail_with_reason(reason, varargin{:});
end
