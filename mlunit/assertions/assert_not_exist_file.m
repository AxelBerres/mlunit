function assert_not_exist_file(file, varargin)
%ASSERT_NOT_EXIST_FILE Raise an error if a file or directory exists.
%  ASSERT_NOT_EXIST_FILE(FILE) calls exist(FILE, 'file') and raises a MATLAB
%  error if it does not yield 0. This also works for directories.
%  Use a file extension with FILE. If you omit the extension, MATLAB may find a
%  file or directory of the same name.
%
%  ASSERT_NOT_EXIST_FILE(FILE, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_NOT_EXIST_FILE() just passes.
%
%  Examples
%     % assert that foobarxyz does not exist
%     assert_not_exist_file('foobarxyz', 'Why would you name anything foobarxyz?');
%
%  See also  MLUNIT_FAIL

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin >= 1
   existResult = exist(file, 'file');
   
   if 0 == existResult
      return
   else
      reason = sprintf('Expected absent entity exists as %s: %s', mlunit_getExistType(existResult), file);
   end
   
   mlunit_fail_with_reason(reason, varargin{:});
end
