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

function [state, errors] = mlunit_environment(state)

    errors = [];

    % if input argument, reset states to it
    if nargin > 0
        envErrors = loc_restore_environment(state);
        if ~isempty(envErrors)
            errors = struct('message', {envErrors});
        end
        state = [];

    % return current environment state
    else
        state = loc_current_environment();
    end

% Collect environment information in a single state variable
% This collects the current directory, the current MATLAB path configuration,
% and the current mlunit parameter configuration.
function state = loc_current_environment()

    state.pwd = cd;
    state.config = mlunit_param();
    state.path = path;
    state.blockdiagrams_loaded = find_system('SearchDepth', 0);

% Reset the environment to the information stored in the state variable.
function errors = loc_restore_environment(state)

    errorsRestore = loc_restore_blockdiagrams_loaded(state);
    
    cd(state.pwd);
    if (~strcmp(state.path, path))
        path(state.path);
    end

    % Delete tempdirs after resetting the path, otherwise MATLAB may warn about it
    % removing dirs from the MATLAB search path on its own account.
    errorsDelete = loc_delete_tempdirs(state.config);
    errors = [errorsRestore, errorsDelete];
    
    % Reset states last, as loc_delete_tempdirs needs the current state.
    mlunit_param(state.config);
    
% Delete mlunit_tempdir directories that have been added since the previous recorded state
function errors = loc_delete_tempdirs(prevConfig)

    prevTempdirs = {};
    if isfield(prevConfig, 'mlunit_tempdirs') && ~isempty(prevConfig.mlunit_tempdirs)
        prevTempdirs = prevConfig.mlunit_tempdirs;
    end
    
    currTempdirs = mlunit_param('mlunit_tempdirs');
    if isempty(currTempdirs)
        currTempdirs = {};
    end
    
    removeTempdirs = setdiff(currTempdirs, prevTempdirs);
    errors = '';
    for i = 1:numel(removeTempdirs)
        [success, message, msgid] = rmdir(removeTempdirs{i}, 's');
        % record errors, but accept when the directory has already been deleted
        if ~success && ~strcmp('MATLAB:RMDIR:NotADirectory', msgid)
            errors = [errors, sprintf([...
                'Error removing temporary directory:\n' ...
                '    directory: %s\n' ...
                '    messageid: %s\n' ...
                '    message  : %s\n' ...
                ], removeTempdirs{i}, msgid, message)]; %#ok<AGROW>
        end
        % if the dir contains open files, rmdir issues MATLAB:RMDIR:NoDirectoriesRemoved
    end

% Close the block diagrams that are not saved in the state (excluding the
% simulink and TargetLink library)
function errors = loc_restore_blockdiagrams_loaded(state)

    blockdiagrams_loaded_now = find_system('SearchDepth', 0);
    blockdiagrams_to_close = setdiff(blockdiagrams_loaded_now, state.blockdiagrams_loaded);
    blockdiagrams_to_close = blockdiagrams_to_close(~strcmpi(blockdiagrams_to_close, 'simulink'));
    blockdiagrams_to_close = blockdiagrams_to_close(~strcmpi(blockdiagrams_to_close, 'tllib'));
    
    % Close diagrams item by item. Otherwise, in case of multiple problems, bdclose
    % encapsulates individual problem's messages in a structured
    % "Error due to multiple causes" error, which would need structured handling anyway.
    errors = '';
    for i = 1:numel(blockdiagrams_to_close)
        try
            bdclose(blockdiagrams_to_close{i});
        catch bdcloseException
            if strcmpi('Simulink:Engine:InvModelClose', bdcloseException.identifier)
                % Just the message for a lagging compile is telling enough.
                errors = [errors, sprintf( ...
                    'Error: %s\n', ...
                    loc_filter_html_anchors(bdcloseException.message))]; %#ok<AGROW>
            else
                % Simulink's exception reports usually start with "Error" themselves.
                errors = [errors, sprintf( ...
                    '%s\n', ...
                    loc_filter_html_anchors(bdcloseException.getReport()))]; %#ok<AGROW>
            end
        end
    end

function plaintext = loc_filter_html_anchors(htmltext)
    
    if ~mlunit_param('linked_trace')
        expression = ['<a href=[^>]*>' ...  % <a> tags with any href attribute
                      '([^<]*)' ...         % tag content
                      '</a>'];              % </a> closing tag
        plaintext = regexprep(htmltext, expression, '$1');
    else
        plaintext = htmltext;
    end
