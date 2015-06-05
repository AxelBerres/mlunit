function assert_false(expr, varargin)
%ASSERT_FALSE Raise an error if expression evaluates to true.
%  ASSERT_FALSE(EXPR) evaluates EXPR and raises a MATLAB error if it yields
%  MATLAB's notion of true, i.e. logical 1 or numericals > 0.
%
%  ASSERT_FALSE(EXPR, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_FALSE() raises a MATLAB error.
%
%  Examples
%     % asserts string variable arg not being empty
%     assert_false(isempty(arg));
%
%     % asserts variable arg not being a cell array
%     assert_false(iscell(arg), 'Input argument should not be a cell array');
%
%  See also  MLUNIT_FAIL, ASSERT_TRUE

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: assert_false.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 1 || expr
    reason = 'Expected false was actually true.';
    mlunit_fail_with_reason(reason, varargin{:});
end
