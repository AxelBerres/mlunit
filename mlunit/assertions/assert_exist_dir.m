function assert_exist_dir(dir, varargin)
%ASSERT_EXIST_DIR Raise an error if a directory does not exist.
%  ASSERT_EXIST_DIR(DIR) calls exist(DIR, 'dir') and raises a MATLAB error if it does
%  not yield 7.
%
%  ASSERT_EXIST_DIR(DIR, MSG, varargin) does the same, but with the custom
%  error message MSG. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin.
%
%  ASSERT_EXIST_DIR(DIR, TYPE) calls exist(DIR, 'dir') and raises a MATLAB error if it
%  does not yield TYPE. TYPE may be a vector of expected exist return values.
%
%  ASSERT_EXIST_DIR(DIR, TYPE, MSG, varargin) again, with the custom error message MSG.
%
%  ASSERT_EXIST_DIR() just passes.
%
%  Examples
%     % assert that MATLAB's root dir exists
%     assert_exist_dir(matlabroot, 'Started MATLAB interpreter but missing its root directory.');
%
%     % assert that a (not yet created) temporary dir does not exist
%     assert_exist_dir(tempname, 0, 'Temporary path exists, but should not yet.');
%
%  See also  MLUNIT_FAIL

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if nargin >= 1
   existResult = exist(dir, 'dir');
   
   % Check against user-given types
   if nargin >= 2 && isnumeric(varargin{1})
      expectedType = varargin{1};
      varargin = varargin(2:end);
      
      if any(expectedType == existResult)
         return
      end
      
      reason = loc_customTypeFailMessage(dir, expectedType, existResult);
   
   % Check against default types
   else
      switch existResult
         case 7  % valid dir
            return
         case 0
            reason = sprintf('Expected directory does not exist: %s', dir);
         otherwise
            reason = sprintf('Expected directory is actually %s: %s', mlunit_getExistType(existResult), dir);
      end
   end
   
   mlunit_fail_with_reason(reason, varargin{:});
end

function reason = loc_customTypeFailMessage(dir, expectedType, existResult)

   if 1 == numel(expectedType)
      expectedText = sprintf('%s (%s)', mat2str(expectedType), mlunit_getExistType(expectedType));
   else
      expectedText = mat2str(expectedType);
   end
   actualText = sprintf('%s (%s)', mat2str(existResult), mlunit_getExistType(existResult));
   reason = sprintf('Expected exist result does not match actual result:\n  %-9s: %s\n  %-9s: %s\n  %-9s: %s', ...
      'Directory', dir, ...
      'Expected', expectedText, ...
      'Actual', actualText);
