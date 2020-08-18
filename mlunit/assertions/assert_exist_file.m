function assert_exist_file(expr, varargin)
%ASSERT_EXIST_FILE Raise an error if a file does not exist.
%  ASSERT_EXIST_FILE(FILE) calls exist(FILE, 'file') and raises a MATLAB error if it does
%  not yield 2, 3, 4, or 6 (file, mex-file, Simulink model, p-code file).
%  Use a file extension with FILE. If you omit the extension, MATLAB will find a
%  mex-file of the same name, when you really wanted to find a p-coded file.
%  Providing just one specific TYPE won't fix this, as there is a precedence
%  order for files of the same type. The precedence order changes in the course
%  of MATLAB releases. Use a file extension.
%
%  ASSERT_EXIST_FILE(FILE, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_EXIST_FILE(FILE, TYPE) calls exist(FILE, 'file') and raises a MATLAB error if it
%  does not yield TYPE. TYPE may be a vector of expected exist return values.
%  You may use ASSERT_EXIST_FILE to check for directory existence (value 7).
%  However, there is no guarantee for a specific return value. If even you check
%  for a random file (2), MATLAB may unexpectedly return 3, 4, or 6, depending
%  on the extension. Therefore only use 2, if you checked that the extension not
%  be .mdl, .slx, .mexw32, .mexw64, or .p.
%
%  ASSERT_EXIST_FILE(FILE, TYPE, MSG, varargin) again, with the custom error message MSG.
%
%  ASSERT_EXIST_FILE() just passes.
%
%  Examples
%     % assert that MATLAB's own function 'ver' exists
%     assert_exist_file('ver', 'MATLAB is not correctly installed.');
%
%     % assert that a (not yet created) temporary file does not exist
%     assert_exist_file(tempname, 0, 'Temporary path exists, but should not yet.');
%
%  See also  MLUNIT_FAIL

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin >= 1
   existResult = exist(expr, 'file');
   
   % Check against user-given types
   if nargin >= 2 && isnumeric(varargin{1})
      expectedType = varargin{1};
      varargin = varargin(2:end);
      
      if any(expectedType == existResult)
         return
      end
      
      reason = loc_customTypeFailMessage(expr, expectedType, existResult);
   
   % Check against default types
   else
      switch existResult
         case {2, 3, 4, 6}  % valid files
            return
         case 0
            reason = sprintf('Expected file does not exist: %s', expr);
         otherwise
            reason = sprintf('Expected file is actually %s: %s', mlunit_getExistType(existResult), expr);
      end
   end
   
   mlunit_fail_with_reason(reason, varargin{:});
end

function reason = loc_customTypeFailMessage(expr, expectedType, existResult)

   if 1 == numel(expectedType)
      expectedText = sprintf('%s (%s)', mat2str(expectedType), mlunit_getExistType(expectedType));
   else
      expectedText = mat2str(expectedType);
   end
   actualText = sprintf('%s (%s)', mat2str(existResult), mlunit_getExistType(existResult));
   reason = sprintf('Expected exist result does not match actual result:\n  %-9s: %s\n  %-9s: %s\n  %-9s: %s', ...
      'File', expr, ...
      'Expected', expectedText, ...
      'Actual', actualText);
