% Execute a single test case.
% The test case must exist. The test argument is the respective test case
% object.
% The returned result is a scalar struct with fields:
%   - name    : string, the test case name, mandatory
%   - errors  : struct array, all errors that occurred during execution, each 
%               a struct in itself with fields message and stack,
%               0x0 struct with these fields, if no errors occurred
%   - failure : string, the failure message, empty, if no failure occurred
%   - time    : double, the execution time in seconds

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: load_tests_from_mfile.m 173 2012-06-12 09:26:53Z alexander.roehnsch $

function [result, test] = run_test(self, test)

    start_time = clock;

    % buffer environment for reset after each test case
    previous_environment = mlunit_environment();
    
    % execute set_up fixture
    setup_error = loc_errstruct();
    try
        test = set_up(test);
    catch
        setup_error = loc_errstruct(lasterror, 'error in set_up fixture');
    end

    % execute test, only if set_up prevailed
    test_error = loc_errstruct();
    test_failure = '';
    if isempty(setup_error)
        method = get_name(test);
        try
            test = eval([method, '(test)']);
        catch
            err = lasterror;
            errmsg = err.message;
            isfailure = strcmp(err.identifier, 'MLUNIT:Failure');
            if isfailure
                % filter up to 'MLUNIT FAILURE' string, which is used for masking actual error message
                failurepos = strfind(errmsg, 'MLUNIT FAILURE:');
                test_failure = errmsg(failurepos(1) + 15:length(errmsg));
                if isempty(test_failure)
                    test_failure = '(no failure message available)';
                end
            else
                % Add some stack if missing. But why would it be missing?
                % TODO: investigate
                if (~isfield(err, 'stack'))
                    err.stack(1).file = char(which(method));
                    err.stack(1).line = '1';
                    err.stack = vertcat(err.stack, dbstack('-completenames'));
                end

                test_error = loc_errstruct(err);
            end;
        end;
    end;

    % execute tear_down fixture in any case, even if set_up or test failed
    teardown_error = loc_errstruct();
    try
        test = tear_down(test); 
    catch
        teardown_error = loc_errstruct(lasterror, 'error in tear_down fixture');
    end

    % restore previous environment after test and fixtures finished
    mlunit_environment(previous_environment);

    % build result structure
    result = struct();
    result.name = get_name(test);
    result.errors = vertcat(setup_error, test_error, teardown_error);
    result.failure = test_failure;
    result.time = etime(clock, start_time);
    
    % update progress listeners with latest test result
    for lidx=1:numel(self.listeners)
        self.listeners{lidx} = next_result(self.listeners{lidx}, result);
    end


% Return an arrayable error struct with fixed fieldnames.
function errstruct = loc_errstruct(lasterror, message_prefix)

    % provide 0x0 struct with correct fieldnames for array aggregation
    if nargin == 0
        errstruct = struct(...
            'message', {}, ...
            'stack', {});
        return;
    end
    
    if nargin < 2
        message_prefix = '';
    else
        % set prefix one line before
        message_prefix = [message_prefix sprintf('\n')];
    end

    errstruct = struct();
    errstruct.message = [message_prefix lasterror.message];
    if isempty(errstruct.message)
        errstruct.message = '(no error message available)';
    end
    errstruct.stack = loc_print_stack(lasterror.stack);
    errstruct = parse_error(errstruct);
    
% Build a single string containing the stack lines.
function stackstring = loc_print_stack(stack)
    
    stackstring = '';
    for i = 1:size(stack, 1)
        stackstring = sprintf('%s\nIn %s at line %d', ...
            stackstring, ...
            stack(i).file, stack(i).line);
    end

% Parse special errors to extract further stacktrace information.
% Author: Thomas Dohmke <thomas@dohmke.de>
function errstruct = parse_error(errstruct) %#ok<INUSL>

    if (~isempty(strfind(errstruct.message, 'Unbalanced or misused parentheses or brackets.')) || ...
        ~isempty(strfind(errstruct.message, 'Unbalanced or unexpected parenthesis or bracket.')))
        % ignore MATLAB's HTML anchor tags
        % allow for Jenkins' <URL/filename> syntax, also for parentheses in paths
        [tokens] = regexp(errstruct.message, 'Error:\s*(<a href[^>]*>)?File: <?([\w\ \.,$&\/\(\)\\:@]+.m)>? Line: (\d*) Column: (\d*).*', 'tokens', 'once');
        if (length(tokens) == 4)
            fullname = which(char(tokens(2)));
            if (~isempty(fullname))
                errstruct.stack = sprintf('\nIn %s at line %s%s', ...
                    fullname, char(tokens(3)), ...
                    errstruct.stack);
            else
                errstruct.stack = sprintf('\nIn %s at line %s%s', ...
                    char(tokens(2)), char(tokens(3)), ...
                    errstruct.stack);
            end;
            errstruct.message = 'Unbalanced or misused parentheses or brackets.';
        end;
    else
        [tokens] = regexp(errstruct.message, 'Error using ==> <a href.*>(.*)</a>\n(.*)', 'tokens', 'once');
        if (length(tokens) == 2)
            errstruct.message = char(tokens(2));
        end;
    end
