function assert_not_equals_withequalnans(expected, actual, msg, varargin)
%ASSERT_NOT_EQUALS_WITHEQUALNANS Raise an error if two expressions evaluate
%to the same.
%  ASSERT_NOT_EQUALS_WITHEQUALNANS works exactly like ASSERT_NOT_EQUALS, but in
%  the background uses isequalwithequalnans() rather than isequal() to determine
%  equality. That is why NaN values will be considered equal.
%
%  See also  FAIL, ASSERT_EQUALS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 2
   fail('assert_not_equals_withequalnans: Not enough input arguments.');
end

if nargin < 3 || isempty(msg)
   msg = sprintf('Expected same <%s> was not <%s>.', to_string(expected), to_string(actual));
end

if isequalwithequalnans(actual, expected)
   fail(msg, varargin{:});
end


%% subfunction to_string
function outstring = to_string(input)

   if ischar(input)
      outstring = input;
   elseif isnumeric(input) || islogical(input)
      outstring = num2str(input);
   elseif isstruct(input)
      outstring = 'MATLAB structure array';
   elseif iscell(input)
      outstring = 'MATLAB cell array';
   else
      outstring = 'unrecognized type';
   end
