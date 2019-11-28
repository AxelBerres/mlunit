%Save and restore MATLAB/mlUnit environment.
%  The environment information are stored in a single state variable.
%  You can pass around the state, buffer it, or manage several different states
%  at the same time.
%  
%  The environment state contains the current directory, the current MATLAB
%  path configuration, the Simulink block diagrams loaded and the current
%  mlunit parameter configuration.
%  
%  When the environment is restored, the block diagrams are closed that are
%  loaded but not saved in the state. However, no block diagrams are loaded
%  that are saved in the state but not currently loaded.

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
    state.blockdiagrams_loaded = find_system('SearchDepth', 0);

% Reset the environment to the information stored in the state variable.
function loc_restore_environment(state)

    cd(state.pwd);
    mlunit_param(state.config);
    path(state.path);
    blockdiagrams_loaded_now = find_system('SearchDepth', 0);
    new_blockdiagrams_loaded = setdiff(blockdiagrams_loaded_now, state.all_bds_loaded);
    bdclose(new_blockdiagrams_loaded);