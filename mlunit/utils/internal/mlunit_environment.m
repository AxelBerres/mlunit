%Save and restore MATLAB/mlUnit environment.
%  The environment information are stored in a single state variable.
%  You can pass around the state, buffer it, or manage several different states
%  at the same time.
%  
%  The environment state contains the current directory, the current MATLAB
%  path configuration, the Simulink block diagrams loaded and the current
%  mlunit parameter configuration.
%  
%  When the environment is restored, mlUnit will close new block diagrams,
%  i.e. block diagrams that have been loaded after the latest state save.
%  On the other hand, mlUnit leaves missing block diagrams closed, i.e.
%  block diagrams that were loaded before the latest state save, but have
%  been closed thereafter by the test.
%
%  The Simulink library ('simulink') and TargetLink library ('tllib') are
%  treated differently when restoring the environment. These libraries are
%  usually loaded in Matlab, but may have been closed by bdclose('all')
%  before running the tests. If a test needs these libraries, it should
%  load the libraries itself. For runtime reasons, mlunit does not close
%  these large libraries when restoring the environment, to prevent these
%  libraries from being reloaded repeatedly. Since these libraries are
%  normally loaded anyway, closing them is not necessary.

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
    loc_restore_blockdiagrams_loaded(state);
    
% Close the block diagrams that are not saved in the state (excluding the
% simulink and TargetLink library)
function loc_restore_blockdiagrams_loaded(state)

    blockdiagrams_loaded_now = find_system('SearchDepth', 0);
    blockdiagrams_to_close = setdiff(blockdiagrams_loaded_now, state.blockdiagrams_loaded);
    blockdiagrams_to_close = blockdiagrams_to_close(~strcmpi(blockdiagrams_to_close, 'simulink'));
    blockdiagrams_to_close = blockdiagrams_to_close(~strcmpi(blockdiagrams_to_close, 'tllib'));
    bdclose(blockdiagrams_to_close);