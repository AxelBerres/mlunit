%Initialize mlUnit execution
%  SELF = INITIALIZE_EXECUTION(SELF, TESTOBJ) tells the listener to set up
%  pre-execution stuff. TESTOBJ may be an absolute path containing test suites,
%  or the name of a specific test suite.
%
%  This method is provided by the user, but should not be called by her.
%
%  See also finalize_execution

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = initialize_execution(self, test_object)

% empty base implementation
