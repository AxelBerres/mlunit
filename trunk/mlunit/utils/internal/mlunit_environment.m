%Save and restore MATLAB/mlUnit environment.
%  The environment information are stored in a single state variable.
%  You can pass around the state, buffer it, or manage several different states
%  at the same time.
%  
%  The environment state contains the current directory, the current
%  MATLAB path configuration, and the current mlunit parameter configuration.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function state = mlunit_environment(state)

    % if input argument, reset states to it
    if nargin > 0
        loc_restore_environment(state);
    end

    % return current environment state
    state = loc_current_environment();

% Collect environment information in a single state variable
% This collects the current directory, the current MATLAB path configuration,
% and the current mlunit parameter configuration.
function state = loc_current_environment()

    state.pwd = cd;
    state.config = mlunit_param();
    state.path = path;

% Reset the environment to the information stored in the state variable.
function loc_restore_environment(state)

    cd(state.pwd);
    mlunit_param(state.config);
    path(state.path);
