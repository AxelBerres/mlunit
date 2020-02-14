function assert_exist_file(expr, varargin)
%ASSERT_EXIST_FILE Raise an error if a file does not exist.
%  ASSERT_EXIST_FILE(FILE) calls exist(FILE, 'file') and raises a MATLAB error if it does
%  not yield 2.
%
%  ASSERT_EXIST_FILE(FILE, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_EXIST_FILE() just passes.
%
%  Examples
%     % assert that MATLAB's own function 'ver' exists
%     assert_exist_file('ver', 'MATLAB is not correctly installed.');
%
%     % (wrongly) assert that a temporary file exists
%     assert_exist_file(tempname, 'Temporary path has not been created yet.');
%
%  See also  MLUNIT_FAIL

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin >= 1
   existResult = exist(expr, 'file');
   switch existResult
      case {2, 3, 4, 6}  % valid files
         return
      case 0
         reason = sprintf('Expected file does not exist: %s', expr);
      otherwise
         reason = sprintf('Expected file is actually %s: %s', loc_getExistType(existResult), expr);
   end
   mlunit_fail_with_reason(reason, varargin{:});
end

function typeString = loc_getExistType(existValue)
   switch existValue
      case 0
         typeString = 'missing';
      case 1
         typeString = 'a variable';
      case 2
         typeString = 'a file';
      case 3
         typeString = 'a MEX-file';
      case 4
         typeString = 'a Simulink model';
      case 5
         typeString = 'a built-in MATLAB function';
      case 6
         typeString = 'a P-code file';
      case 7
         typeString = 'a folder';
      case 8
         typeString = 'a Java class';
      otherwise
         typeString = sprintf('an unknown entity (%g)', existValue);
   end
