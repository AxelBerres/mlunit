%Abstract base class for progress listener implementations.
%  Provided as class in order to force implementations into providing
%  specific methods.
%  Each progress listener must implement four methods:
%  
%    init_suites  - called when the number of suites has been determined,
%                   informing the listener of impending suite execution
%    next_suite   - called just before the next suite is being executed
%    init_results - called when the number of test cases of a suite has been
%                   determined, informing the listener of impending test case
%                   execution
%    next_result  - called just after a test case has executed,
%                   providing its result
%
%  Additionally, listeners may implement two optional methods:
%      
%    initialize_execution - called before anything else
%    finalize_execution   - called after anything else
%
%  See also init_suites, next_suite, init_results, next_result, initialize_execution, finalize_execution

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_progress_listener()

% create instance
self = class(struct(), 'mlunit_progress_listener');
