function assert_warning(func, warnid)
%ASSERT_WARNING Raise an error if a function does not issue a specific warning.
%
%  ASSERT_WARNING(FUNC, WARNID) calls the function handle FUNC and catches the
%  specific warning given as WARNID. Raises a MATLAB error if the function
%  returned without issuing that specific warning. FUNC will be called without
%  input arguments.
%
%  Examples
%     >> wrongpath = 'arbitrary/path/that/should/not/exist';
%     >> assert_warning(@() rmpath(wrongpath), 'MATLAB:rmpath:DirNotFound');
%
%  See also  MLUNIT_FAIL, ASSERT_ERROR

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

% makes sense with both arguments only
error(nargchk(2, 2, nargin, 'struct'));

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
   mlunit_fail(failmsg);
end
