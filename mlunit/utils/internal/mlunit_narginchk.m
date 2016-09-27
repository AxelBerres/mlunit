function message = mlunit_narginchk(low, high, narg)
%mlunit_narginchk Validate number of input arguments. 
%  mlunit_narginchk(LOW,HIGH,N) throws an appropriate error
%  if N is not between LOW and HIGH. If N is in the
%  specified range, no error is thrown.
%
%  MSG = mlunit_narginchk(LOW,HIGH,N) returns an appropriate error message string
%  instead of throwing an error. If N is in the specified range,
%  MSG is the empty string.
%
%  This function replaces MATLAB's nargchk and narginchk.
%  nargchk, because from R2015b onwards, nargchk is unsupported. 
%  narginchk, because it does not exist prior to R2011b.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

errstrings = {'MATLAB:NotEnoughInputs', 'Not enough input arguments.'; ...
              'MATLAB:TooManyInputs', 'Too many input arguments.'};

% check mlunit_narginchk usage
if nargin < 3, error(errstrings{1,:}); end
if nargin > 3, error(errstrings{2,:}); end
if any([numel(low),numel(high),numel(narg)]~=1)
    error('MATLAB:ScalIntReq', 'Scalar integer value required, but value is an array');
end

check_fail = [narg < low, narg > high];

% In case of output argument, only give out message.
message = '';
if nargout > 0
    message = errstrings{check_fail, 2};
    return
end

% Without output argument, throw exception in caller's workspace. HAH!
if any(check_fail)
    if exist('MException', 'file') == 2
        throwAsCaller(MException(errstrings{check_fail,:}))
    else
        error(errstrings{check_fail,:});
    end
end
