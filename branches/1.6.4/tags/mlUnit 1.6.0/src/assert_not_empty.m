function assert_not_empty(expr, varargin)
%ASSERT_NOT_EMPTY Raise an error if expression evaluates to empty.
%  ASSERT_NOT_EMPTY(EXPR) evaluates EXPR and raises a MATLAB error if isempty()
%  yields false. Specifically, isempty(expr) yields false for these
%  examples:   [3 4;5 6] non-empty matrix
%              struct()  one-element structure
%              'v'       non-empty string
%              {[]}      one-element cell array
%
%  ASSERT_NOT_EMPTY(EXPR, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  Examples
%     % asserts variable arg being not empty
%     assert_not_empty(arg);
%
%     % the same, with a custom message
%     assert_not_empty(arg, 'arg found empty');
%
%  See also  ISEMPTY, ASSERT_EMPTY, FAIL, ASSERT

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 1
   fail('assert_not_empty: Not enough input arguments.');
end

if isempty(expr)
   fail(varargin{:});
end
