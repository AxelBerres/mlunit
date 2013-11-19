function assert_warning(warnid, func)
%ASSERT_WARNING Raise an error if a function does not issue a specific warning.
%
%  ASSERT_WARNING(WARNID, FUNC) calls the function handle FUNC and catches the
%  specific warning given as WARNID. Raises a MATLAB error if the function
%  returned without issuing that specific warning.
%
%  Examples
%     >> wrongpath = 'arbitrary/path/that/should/not/exist';
%     >> assert_warning('MATLAB:rmpath:DirNotFound', @() rmpath(wrongpath));
%
%  See also  FAIL, ASSERT_ERROR

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 1, warnid = ''; end
if nargin < 2, func = @()[]; end

% set warning state to error in order to catch in try-catch-statement
prevwarn = warning('error', warnid);

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
   fail(failmsg);
end
