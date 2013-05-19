function assert(expr, varargin)
%ASSERT Raise an error if expression does not evaluate to true.
%  ASSERT(EXPR) evaluates EXPR and raises a MATLAB error if it does
%  not yield MATLAB's notion of true, i.e. logical 1 or numericals > 0.
%
%  ASSERT(EXPR, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT is actually the same as ASSERT_TRUE.
%
%  Examples
%     % asserts string variable arg being empty
%     assert(isempty(arg));
%
%     % asserts variable arg being a cell array; specifies a custom message
%     assert(iscell(arg), 'Input argument is no cell array');
%
%  See also  FAIL

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 1
   fail('assert: Not enough input arguments.');
end

if ~expr
   fail(varargin{:});
end;
