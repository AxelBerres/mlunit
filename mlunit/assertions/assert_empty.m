function assert_empty(expr, varargin)
%ASSERT_EMPTY Raise an error if expression does not evaluate to empty.
%  ASSERT_EMPTY(EXPR) evaluates EXPR and raises a MATLAB error if isempty()
%  does not yield false. Specifically, isempty(expr) yields true for these
%  examples:   []         empty matrix/vector/array
%              struct([]) empty structure array
%              {}         empty cell array
%              ''         empty string
%
%  ASSERT_EMPTY(EXPR, MSG, varargin) does the same, but adds the custom
%  error message MSG at the beginning of the failure reason.
%  MSG may contain sprintf arguments, which can be expanded by subsequent
%  arguments in varargin.
%
%  Examples
%     % asserts variable arg being empty
%     assert_empty(arg);
%
%     % the same, with a custom message
%     assert_empty(arg, 'arg is not empty');
%
%  See also  ISEMPTY, MLUNIT_FAIL, ASSERT_TRUE

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin >= 1 && ~isempty(expr)
    reason = sprintf('Expected empty expression was actually: %s.', printable(expr));
    mlunit_fail_with_reason(reason, varargin{:});
end
