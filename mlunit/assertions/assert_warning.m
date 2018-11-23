function assert_warning(func, warnid, varargin)
%ASSERT_WARNING Raise an error if a function does not issue a specific warning.
%
%  ASSERT_WARNING(FUNC, WARNID) calls the function handle FUNC and catches the
%  specific warning given as WARNID. Raises a MATLAB error if the function
%  returned without issuing that specific warning. FUNC will be called without
%  input arguments.
%
%  ASSERT_WARNING(FUNC, WARNID, MSG, varargin) does the same, but
%  with added custom failure message MSG, which may reference sprintf arguments
%  in varargin.

%
%  Examples
%     >> wrongpath = 'arbitrary/path/that/should/not/exist';
%     >> assert_warning(@() rmpath(wrongpath), 'MATLAB:rmpath:DirNotFound');
%
%  See also  MLUNIT_FAIL, ASSERT_ERROR

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

% makes sense with both arguments only
mlunit_narginchk(2, Inf, nargin);

% set warning state to error in order to catch in try-catch-statement
prevwarn = warning('error', warnid); %#ok<WNTAG>

bCaught = false;
failmsg = ['No warning ' warnid ' when executing function ' func2str(func) '.'];

try
   func();
catch
   err = lasterror;
   if strcmp(err.identifier, warnid)
      bCaught = true;
   else
      failmsg = [failmsg ' But this exception ' err.identifier ...
                 ' with this message: ' err.message];
   end
end

% restore warning state before asserting
warning(prevwarn);

if ~bCaught
   mlunit_fail_with_reason(failmsg, varargin{:});
end
