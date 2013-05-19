function assert_equals(expected, actual, msg, eps, varargin)
%ASSERT_EQUALS Raise an error if two expressions do not evaluate to the same.
%  ASSERT_EQUALS(EXPECTED, ACTUAL) raises a MATLAB error if EXPECTED
%  and ACTUAL are not the same.
%
%  ASSERT_EQUALS(EXPECTED, ACTUAL, MSG, varargin) does the same, but with
%  the custom error message MSG. MSG may contain sprintf arguments, which
%  can be expanded by subsequent arguments in varargin.
%
%  Examples
%     % asserts string variable output being 'yes'
%     assert_equals(output, 'yes');
%
%     % asserts variable arg being 3; specifies a custom message
%     assert_equals(arg, 3, 'Input argument is not %d.', 3);
%
%  See also  FAIL, ASSERT_NOT_EQUALS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id: assert_equals.m 167 2012-06-06 16:10:56Z alexander.roehnsch $

if nargin < 2,
   fail('assert_equals: Not enough input arguments.');
end

if nargin < 3 || isempty(msg),
   msg = sprintf('Expected <%s>, but was <%s>.', to_string(expected), to_string(actual));
end

if nargin < 4,
    eps = 0.001;
end;

% test the values
if isa(expected,'double') && isa(actual,'double')    
    if abs(expected - actual) > eps,
        fail(msg, 1);
    end
elseif ~isequal(actual, expected),
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
