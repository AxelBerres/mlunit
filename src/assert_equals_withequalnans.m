function assert_equals_withequalnans(expected, actual, absolute_eps_or_msg, varargin)
%ASSERT_EQUALS_WITHEQUALNANS Raise an error if two expressions differ.
%  ASSERT_EQUALS_WITHEQUALNANS works exactly like ASSERT_EQUALS, but in the
%  background uses isequalwithequalnans() rather than isequal() to determine
%  equality. That is why NaN values will be considered equal.
%
%  See also  FAIL, ASSERT_EQUALS, ASSERT_NOT_EQUALS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 2
   fail('assert_equals_withequalnans: Not enough input arguments.');
end

% default values for msg and eps
absolute_eps = 0;
msg = sprintf('Expected <%s>, but was <%s>.', to_string(expected), to_string(actual));
msg_args = {};

% Third argument can either be absolute_eps or msg. Handle input args carefully.
if nargin >= 3 && isnumeric(absolute_eps_or_msg)
   absolute_eps = absolute_eps_or_msg;
   msg = [msg sprintf(' Tolerance was <%s>.', to_string(absolute_eps))];
   % if third argument is eps, then the fourth may be the msg and all others the
   % msg sprintf arguments
   if nargin >= 4
      msg = varargin{1};
      msg_args = varargin(2:end);
   end
   
elseif nargin >= 3 && ischar(absolute_eps_or_msg)
   msg = absolute_eps_or_msg;
   msg_args = varargin;
end

% determine equality
if isnumeric(expected) && isequal(class(expected), class(actual))
    % only check against eps if expected and actual both are numeric and have
    % the same type, else MATLAB complains about incompatible types used for
    % subtraction.
    % Be prepared for vectors and matrixes coming in expected and actual.
    if any(abs(expected - actual) > absolute_eps)
        fail(msg, msg_args{:});
    end
% all non-numeric types or mixed numerics, non-numerics are checked by isequal
elseif ~isequalwithequalnans(actual, expected)
    fail(msg, msg_args{:});
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
