function assert_true(expr, varargin)
%ASSERT_TRUE Raise an error if expression does not evaluate to true.
%  ASSERT_TRUE(EXPR) evaluates EXPR and raises a MATLAB error if it does
%  not yield MATLAB's notion of true, i.e. logical 1 or numericals > 0.
%
%  ASSERT_TRUE(EXPR, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_TRUE is actually the same as ASSERT.
%
%  Examples
%     % asserts string variable arg being empty
%     assert_true(isempty(arg));
%
%     % asserts variable arg being a cell array; specifies a custom message
%     assert_true(iscell(arg), 'Input argument is no cell array');
%
%  See also  FAIL, ASSERT, ASSERT_FALSE

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert_true.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 1
   fail('assert_true: Not enough input arguments.');
end

if ~expr
   fail(varargin{:});
end;
