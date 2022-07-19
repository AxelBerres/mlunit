% Rerun tests of the latest test suite collection run.
%
% Rerun all tests or a certain subset of the tests that have run in the latest execution
% of run_suite_collection or recursive_test_run (or any single test suite execution).
% Test results of any succeeding mlunit_rerun call will update the latest results.
% This allows for iterative fixing of test failures/errors.
%
% Any next call to run_suite_collection or recursive_test_run will reset a previous run.
%
% The first parameter selects the subset of the tests.
%
% mlunit_rerun('issues')    - Rerun fails and errors.
% mlunit_rerun('fails')     - Rerun fails. 'failures', 'failed' or 'fail' also work.
% mlunit_rerun('errors')    - Rerun errors.
% mlunit_rerun('all')       - Rerun all tests, also the succeeded ones.
% mlunit_rerun()            - Unless a single test has been selected, default to
%                             'issues', if there are issues, otherwise default to 'all'.
%
% Additionally, you can select single tests.
%
% mlunit_rerun('current')   - Rerun the currently selected test.
% mlunit_rerun('next')      - Rerun the next failure or error and select it.
% mlunit_rerun('nextfail')  - Rerun the next failure and select it. 'nextfailure' also works.
% mlunit_rerun('nexterror') - Rerun the next error and select.
% mlunit_rerun('forget')    - Forget the current selection. 'forgetcurrent' also works.
% mlunit_rerun()            - If a single test has been selected, default to 'current',
%                             rerunning only that particular test.
%
% mlunit_rerun('what')      - Print what mlunit_rerun would do as default action, i.e.
%                             if being called with no arguments.
%
% The following call is reserved for internal use only, and is necessary for
% run_suite_collection to communicate its latest test run to mlunit_rerun.
%
% mlunit_rerun('save', data)

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function mlunit_rerun(flag, data)

    mlunit_narginchk(0, 2, nargin);

    % Handle save hook
    if nargin >= 1 && strcmpi(flag, 'save')
        if nargin < 2
            error('MLUNIT:inputString', 'If the first argument is ''save'', then you need to provide a second argument.');
        end
        
        loc_cache('data', data);
        loc_cache('current', 0);
        return
    end

    % Determine default rerun action, optionally return after help
    doHelp = nargin > 0 && strncmpi(flag, 'what', 4);
    doDefaultAction = nargin == 0 || isempty(flag);
    if doDefaultAction || doHelp

        inIteration = loc_cache('inIteration');
        hasIssues = loc_cache('hasIssues');

        if inIteration
            defaultAction = 'current';
            disp('Rerunning current issue.');
        elseif hasIssues
            defaultAction = 'issues';
            disp('Rerunning remaining issues.');
        else
            defaultAction = 'all';
            disp('Rerunning all previously executed tests.');
        end
        
        if doHelp
            loc_printHelp(inIteration, hasIssues);
            return
        end

        flag = defaultAction;
    end
    
    % Normalize flag value
    if     strncmpi(flag, 'fail', 4),       flag = 'fails';
    elseif strncmpi(flag, 'error', 5),      flag = 'errors';
    elseif strncmpi(flag, 'issue', 5),      flag = 'issues';
    elseif strncmpi(flag, 'nextfail', 8),   flag = 'nextfail';
    elseif strncmpi(flag, 'nexterror', 9),  flag = 'nexterror';
    elseif strncmpi(flag, 'next', 4),       flag = 'next';      % includes 'nextissue'
    elseif strncmpi(flag, 'forget', 6),     flag = 'forget';
    % Flag 'all' needs to be given in those letters.
    end
    
    % Reject invalid input
    % Throwing errors here does not delete the cache, but saving the file does
    validFlags = {'all', 'issues', 'errors', 'fails', 'current', 'next', 'nextfail', 'nexterror', 'forget'};
    if ~any(strcmpi(flag, validFlags))
        error('MLUNIT:inputString', 'Invalid flag ''%s''.', flag);
    end
    if strcmpi(flag, 'current') && ~loc_cache('inIteration')
        error('MLUNIT:currentSingleResult', 'Run mlunit_rerun(''current'') only after having selected a test by calling ''next''.');
    end
    
    % Cache suites
    data = loc_cache('data');

    % Get suitespecs subset for the requested rerun
    [suitespecs, returnNow] = loc_getSuitespecsForFlag(flag);
    if returnNow
        return
    end
   
    % Run test or test suite
    index = loc_cache('current');
    suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
    run_suite_collection(suite_runner, suitespecs);

    % Write back current index, overwritten by run_suite_collection
    loc_cache('current', index);

    % Fetch new results saved by run_suite_collection
    newdata = loc_cache('data');

    % Update previously collected suites with results
    data.suiteresults = loc_updateResults(data.suiteresults, newdata.suiteresults);
    loc_cache('data', data);
end

% Print overview over tests marked for rerun.
function loc_printHelp(inIteration, hasIssues)
    if inIteration
        [rerun_entries, numSuites, idxCurrent] = loc_getIssuesInfo();
        for i = 1:numel(rerun_entries)
            if i == idxCurrent
                rerun_entries{i} = ['--> ', rerun_entries{i}];
            else
                rerun_entries{i} = ['    ', rerun_entries{i}];
            end
        end
    
        disp(' ');
        disp(mlunit_strjoin(rerun_entries, '\n'));
        disp(' ');
        fprintf('    One out of %d tests across %d suites\n\n', numel(rerun_entries), numSuites);
    elseif hasIssues
        [rerun_entries, numSuites] = loc_getIssuesInfo();
    
        disp(' ');
        disp(['    ', mlunit_strjoin(rerun_entries, '\n    ')]);
        disp(' ');
        fprintf('    %s across %s\n\n', loc_grammaticNumeral(numel(rerun_entries), 'test'), loc_grammaticNumeral(numSuites, 'suite'));
    else
        rerun_entries = loc_getSuiteNames();
    
        if ~isempty(rerun_entries)
            disp(' ');
            disp(['    ', mlunit_strjoin(rerun_entries, '\n    ')]);
        end
        disp(' ');
        fprintf('    %s\n\n', loc_grammaticNumeral(numel(rerun_entries), 'suite'));
    end
end

% Output '1 apple' but '4 apples' and '0 apples'.
function out = loc_grammaticNumeral(count, name)
    if count == 1
        out = sprintf('%d %s', count, name);
    else
        out = sprintf('%d %ss', count, name);
    end
end

% Get tests subset for the requested rerun, in the form of a session-transferable
% suitespec container.
function [specObject, returnNow] = loc_getSuitespecsForFlag(flag)

    specObject = [];
    returnNow = false;
    switch lower(flag)
        case 'all'
            specObject = loc_generateRerunSpec(0, 0);
        case 'errors'
            specObject = loc_generateRerunSpec(1, 0);
        case 'fails'
            specObject = loc_generateRerunSpec(0, 1);
        case 'issues'
            specObject = loc_generateRerunSpec(1, 1);
        
        case 'current'
            specObject = loc_getIssueSpecObject();
        case 'forget'
            loc_cache('current', 0);
            specObject = loc_getIssueSpecObject(0);
            returnNow = true;
            disp('Forgot the currently selected test.');
            
        case 'next'
            specObject = loc_getNextIssueSpecObject('');
        case 'nextfail'
            specObject = loc_getNextIssueSpecObject('failure');
        case 'nexterror'
            specObject = loc_getNextIssueSpecObject('error');
    end
    
    if strncmpi(flag, 'next', 4) && isempty(specObject.suitespecs)
        switch flag
            case 'nextfail'
                issueType = 'failure';
            case 'nexterror'
                issueType = 'error';
            otherwise
                issueType = '';
        end
        issueString = issueType;
        if isempty(issueString)
            issueString = 'issue';
        end
        
        disp(' ');
        disp(['You''re at the end of ', issueString, 's.']);
        
        if loc_hasIssues('', issueType)
            disp('The next mlunit_rerun call with a ''next'' flag will restart from the beginning.');
        else
            disp(['There are no further ', issueString, 's available. Look at the current results using mlunit_rerun(''issues'').']);
        end
        returnNow = true;
    end
end

% Overwrite suiteresults' test results with newresults'
function suiteresults = loc_updateResults(suiteresults, newresults)
    
    % We iterate newresults, as it is a direct subset of suiteresults.
    for suite = 1:numel(newresults)
        suitename = newresults{suite}.name;
        srindex = cellfun(@(r)strcmp(r.name, suitename), suiteresults);
        if sum(srindex) == 1
            suiteresults{srindex}.testcaseList = loc_updateTests(suiteresults{srindex}.testcaseList, newresults{suite}.testcaseList);
        else
            error('MLUNIT:resultIndexing', 'Found %s suites of name %s in results data. Was expecting 1.', num2str(sum(srindex)), suitename);
        end
    end
end

% Overwrite tclist's test results with newlist's
function tclist = loc_updateTests(tclist, newlist)
    
    % We iterate newlist, as it is a direct subset of tclist.
    for test = 1:numel(newlist)
        testname = newlist{test}.name;
        tcindex = cellfun(@(t)strcmp(t.name, testname), tclist);
        if sum(tcindex) == 1
            tclist{tcindex} = newlist{test};
        else
            error('MLUNIT:testIndexing', 'Found %s test cases of name %s in results data. Was expecting 1.', num2str(sum(tcindex)), testname);
        end
    end
end

% Did any test resulted in a failure or error?
% We query the test's results directly, not the suiteresult's aggregation,
% because we don't update the aggregation in loc_updateResults when results heal.
function hasIssues = loc_hasIssues(suiteresults, issueType)

    if nargin < 1 || isempty(suiteresults)
        suiteresults = getfield(loc_cache('data'), 'suiteresults');
    end

    if nargin < 2
        issueType = '';
    end
    
    if isempty(issueType)
        nextFail  = loc_getNextErrorOrFail(suiteresults, 0, 'failure');
        nextError = loc_getNextErrorOrFail(suiteresults, 0, 'error');
        nextIssue = loc_getPriorIssue(nextFail, nextError);
    else
        nextIssue = loc_getNextErrorOrFail(suiteresults, 0, issueType);
    end
    
    hasIssues = nextIssue(1) > 0;
end

% Find the names of all tests that are either failures or errors.
function [info, numSuites, idxCurrent] = loc_getIssuesInfo()

    data = loc_cache('data');
    current = loc_cache('current');
    suiteresults = data.suiteresults;

    info = {};
    idxCurrent = 0;
    markedSuites = zeros(size(suiteresults));
    for idxSuite = 1:numel(suiteresults)

        tests = suiteresults{idxSuite}.testcaseList;
        for idxTest = 1:numel(tests)

            isError = ~isempty(tests{idxTest}.error);
            isFailure = ~isempty(tests{idxTest}.failure);
            isCurrent = current(1) == idxSuite && current(2) == idxTest;

            if isError || isFailure || isCurrent
                testName = [suiteresults{idxSuite}.name, '.', tests{idxTest}.name];
                markedSuites(idxSuite) = 1;

                if isError
                    info{end+1} = [testName, ' (error)']; %#ok<AGROW> 
                elseif isFailure
                    info{end+1} = [testName, ' (failure)']; %#ok<AGROW> 
                else
                    % This branch only applies if the user healed the currently selected
                    % test case. Then we still want to list it in the overview.
                    info{end+1} = [testName, ' (passed)']; %#ok<AGROW> 
                end

                if isCurrent
                    idxCurrent = numel(info);
                end
            end
        end
    end
    numSuites = sum(markedSuites);
end

% Get all suite names.
function names = loc_getSuiteNames()
    data = loc_cache('data');
    names = cellfun(@(s)s.name, data.suiteresults, 'UniformOutput', false);
end

% Which issue is the prior one, while being valid (not [0, 0])?
function priorIssue = loc_getPriorIssue(kim, sam)

    if kim(1) == 0
        % kim is invalid and sam may be or may be not
        priorIssue = sam;
    elseif sam(1) == 0
        % kim is valid, while sam is not
        priorIssue = kim;
    elseif kim(1) < sam(1) || ...
            (kim(1) == sam(1) && kim(2) < sam(2))
        % both are valid, but kim is preceding
        priorIssue = kim;
    else
        % both are valid, but sam is preceding or equal to kim
        priorIssue = sam;
    end
end

% Get the spec object of the next issue, and select that issue.
function output = loc_getNextIssueSpecObject(issueName)

    assert(any(strcmp(issueName, {'failure', 'error', ''})), 'Only ''failure'' or ''error'' allowed as issueName, but was: ''%s''.', issueName);
    
    currentIssue = loc_cache('current');
    data = loc_cache('data');
    
    if any(strcmp(issueName, {'failure', 'error'}))
        nextIssue = loc_getNextErrorOrFail(data.suiteresults, currentIssue, issueName);
    else
        nextError = loc_getNextErrorOrFail(data.suiteresults, currentIssue, 'error');
        nextFail  = loc_getNextErrorOrFail(data.suiteresults, currentIssue, 'failure');
        nextIssue = loc_getPriorIssue(nextFail, nextError);
    end
    loc_cache('current', nextIssue);
    
    output = loc_getIssueSpecObject(nextIssue, data);
end

% Get a session-transferable object containing a rerun suitespec for a single test.
function output = loc_getIssueSpecObject(index, data)
    
    if nargin < 1
        index = loc_cache('current');
    end
    if nargin < 2
        data = loc_cache('data');
    end

    if index(1) > 0
        suitespec = {data.suiteresults{index(1)}.suitespec};
        suitespec{1}.testselection = {data.suiteresults{index(1)}.testcaseList{index(2)}.name};
    else
        suitespec = {};
    end
    output = struct(...
        'testobj', {data.testobj}, ...
        'suitespecs', {suitespec});
end

% Determine the suite/test index of the next issue/error/failure.
% If there is no next issue, return [0, 0], indicating to start from the front again.
% If there absolutely are no issues, the caller should output a proper message.
function nextIssue = loc_getNextErrorOrFail(suiteresults, currentIssue, issueName)

    assert(any(strcmp(issueName, {'failure', 'error'})), 'Only ''failure'' or ''error'' allowed as issueName.');

    nextIssue = [0, 0];

    % Start iteration
    if currentIssue(1) == 0
        currentIssue = [1, 0];
    end
    
    for s = currentIssue(1):numel(suiteresults)
        idxFirstTest = 1;
        if s == currentIssue(1)
            idxFirstTest = currentIssue(2) + 1;
        end
        for t = idxFirstTest:numel(suiteresults{s}.testcaseList)
            if ~isempty(suiteresults{s}.testcaseList{t}.(issueName))
                if ~all([s, t] == currentIssue)
                    nextIssue = [s, t];
                    return
                end
            end
        end
    end
end

% Cached data object
% 
% Following predicates are available, additionally:
%    'inIteration'    - Are we in iteration mode?
%    'hasIssues'      - Are there failures or errors in the last run?
function output = loc_cache(flag, input)
    
    persistent data;
    persistent current;
    
    if isempty(data)
        data = struct('suiteresults', {{}}, 'testobj', {''});
        current = 0;
    end
    
    if nargin == 0 || isempty(flag)
        flag = 'data';
    end
    
    % Output previous state information
    switch lower(flag)
        case 'data'
            output = data;

        case 'current'
            output = current;

        case 'initeration'
            output = current(1) > 0;

        case 'hasissues'
            output = loc_hasIssues(data.suiteresults);
    end
    
    if nargin < 2
        return
    end
    
    % Save input state information
    if strcmpi(flag, 'data')
        data = input;
    elseif strcmpi(flag, 'current')
        current = input;
    end
end

% Get a session-transferable object containing a rerun suitespec for a test subset.
function specObject = loc_generateRerunSpec(getErrors, getFails)

    data = loc_cache('data');

    if ~getErrors && ~getFails
        rerunspecs = cellfun(@loc_singleSuiteRerunSpec, data.suiteresults, 'UniformOutput', false);
    else
        rerunspecs = cellfun(@(d)loc_singleSuiteRerunSpec(d, getErrors, getFails), data.suiteresults, 'UniformOutput', false);
        rerunspecs(cellfun('isempty', rerunspecs)) = [];
    end
    specObject = struct(...
        'testobj', {data.testobj}, ...
        'suitespecs', {rerunspecs});
end

% Get a rerun suitespec for a single test suite.
function suitespec = loc_singleSuiteRerunSpec(suite, getErrors, getFails)
    if nargin < 3
        testcases = cellfun(@(r)r.name, suite.testcaseList, 'UniformOutput', false);
    else
        testcases = loc_filterTestcaseNames(suite.testcaseList, getErrors, getFails);
    end
    
    if isempty(testcases)
        suitespec = [];
    else
        suitespec = suite.suitespec;
        suitespec.testselection = testcases;
    end
end

% Get the names of a suite's testcase names that are either errors, failures, or both.
function names = loc_filterTestcaseNames(tests, getErrors, getFails)
    names = cell(size(tests));
    idxContent = false(size(tests));
    for t = 1:numel(tests)
        if (~isempty(tests{t}.error) && getErrors) || ...
           (~isempty(tests{t}.failure) && getFails)
           names{t} = tests{t}.name;
           idxContent(t) = true;
        end
    end
    names = names(idxContent);
end
