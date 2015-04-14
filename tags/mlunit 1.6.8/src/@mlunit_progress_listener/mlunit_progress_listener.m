%Abstract base class for progress listener implementations.
%  Provided as class in order to force implementations into providing
%  specific methods.
%  Each progress listener must implement two methods:
%    - init_results
%    - next_result
%
%  See also init_results, next_result

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_progress_listener()

% create instance
self = class(struct(), 'mlunit_progress_listener');
