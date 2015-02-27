%Update display with next test case result.
%
%  SELF = next_result(SELF, RESULT) notifies the listener of a completed test
%  run, providing it with the result. SELF is a mlunit_gui_listener instance.
%  RESULT is the test result as returned by run_test().
%
%  This method is provided by the user, but should not be called by her.
%
%  See also init_results, run_test

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = next_result(self, result)

error('MLUNIT:missingOverload', 'Abstract base implementation for method ''%s''needs overloading.', mfilename);
