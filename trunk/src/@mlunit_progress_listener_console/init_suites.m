%Begin listening to incoming suites.
%  SELF = INIT_SUITES(SELF, MAXNUM) tells the listener to prepare herself for
%  subsequent next_suite calls. There will be exactly MAXNUM next_suite calls
%  for this run, each providing the name of the next pending test suite.
%
%  This method is provided by the user, but should not be called by her.
%
%  See also next_suite

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = init_suites(self, num_results)

% nothing to be done here
