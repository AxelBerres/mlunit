function assert_contains(str, pattern, varargin)
%ASSERT_CONTAINS Raise an error if some pattern cannot be found in a text.
%  ASSERT_CONTAINS(STR, PATTERN) calls strfind and raises a MATLAB error if PATTERN is not
%  contained in STR. STR may be a char array, or a cell array of strings. PATTERN must be
%  a char array.
%
%  ASSERT_CONTAINS(STR, PATTERN, MSG, varargin) does the same, but adds the custom
%  error message MSG at the beginning of the failure reason.
%  MSG may contain sprintf arguments, which can be expanded by subsequent
%  arguments in varargin.
%
%  Examples
%     assert_contains('foobar', 'oob');
%
%     % fails
%     assert_contains('foobar', 'noob');
%
%  See also  STRFIND, MLUNIT_FAIL

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin < 2
   return
end

if ~ischar(str) &&  ~iscellstr(str)
   error('assert_contain only works on char arrays or cell arrays of character arrays.\nIt was however called with type %s.', class(str));
end
if ~ischar(pattern)
   error('assert_contain''s pattern argument must be a char array.\nIt was however called with type %s.', class(str));
end

if ischar(str) && isempty(strfind(str, pattern))
   
   reason = sprintf('Expected pattern ''%s'' not found in text:\n[''%s'']', pattern, str);
   mlunit_fail_with_reason(reason, varargin{:});

elseif iscellstr(str) && all(cellfun('isempty', strfind(str, pattern)))
   
   reason = sprintf('Expected pattern ''%s'' not found anywhere in cell of strings:\n%s', pattern, printable(str));
   mlunit_fail_with_reason(reason, varargin{:});

end
