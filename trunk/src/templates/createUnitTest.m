% Generates a default unit test for m script.
%
% Description:
% The function creates a unit test case file for ml unit. The given name
% specifies the script under test. By setting b_setup 1 the default set_up 
% and tear_down methods are include. By the string cell array of function 
% names the function creats for each name a default test. This default test
% fails by default.
%
% Syntax: 
%   createUnitTest(s_scriptName, b_setup, s_funNames)
%
% Input:
%   s_scriptName - name for the unit test script 
%   b_setup      - flag for setting the default function set_up and tear_down 
%   s_funNames   - string cell array of function names
%
% EXAMPLES:
% >> createUnitTest('about',0,'version')
% creates a unit test script without set_up and tear_down with a default
% version testfunction
%

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

% Author: Axel Berres
% $Id$
% ------------------------------------------------------------
% revision history:
% 2010/25/08: - created

function createUnitTest(s_scriptName, b_setup, s_funNames)

    % check input parameter
    if nargin < 1, 
        warning('MXRAY:warning', 'missing script name'); 
        return; 
    end

    % set default values of input parameter
    if nargin < 2, b_setup = 1; end
    if nargin < 3, s_funNames = {'test'}; end;
        
    % set test name
    s_testName = ['test_',s_scriptName,'.m'];

    % check if the desired file already exists 
    if exist(s_testName,'file'),
        warning('MXRAY:warning', 'file already exist');
        return;
    end
    
    % create file an write the header
    fid = fopen(s_testName,'w+');
    loc_writeHeader(fid, s_scriptName);
    
    % write setup tear down ...
    if  b_setup, loc_writeSetup(fid); end;
    
    % write defined test cases
    if iscell(s_funNames),
        for i = 1:length(s_funNames)
            s_function = s_funNames{i};
            if ischar(s_function),
                loc_writeTestFun(fid, s_function);
            end
        end
    end

    % close file
    fclose(fid);
    
%% fill header info    
function loc_writeHeader(fid, s_scriptName)

    s_date = datestr(now, 'yyyy/dd/mm');

% TODO: add user and mail address from environment variables
%     s_user = getenv('dev_user');
%     s_mail = getenv('dev_mail');

    fprintf(fid, 'function test = test_%s\n', s_scriptName);
    fprintf(fid, '\n');
    fprintf(fid, '%% Testcase: unit test for %s\n\n',s_scriptName);
    fprintf(fid, '%% *************************************************************************\n');
    fprintf(fid, '%% Copyright:    Model Engineering Solutions GmbH, 2009 - 2010\n');
    fprintf(fid, '%% Date:         $Date: $\n');
    fprintf(fid, '%% Revision:     $Rev: $\n');
    fprintf(fid, '%% Author: Axel Berres axel.berres@model-engineers.com\n');
%     fprintf(fid, '%% Author: %s (%s)\n',s_user, s_mail);
    fprintf(fid, '%% *************************************************************************\n');
    fprintf(fid, '%% revision history:\n');
    fprintf(fid, '%% %s - created\n', s_date);
    fprintf(fid, '\n');
    fprintf(fid, 'test = load_tests_from_mfile(test_loader);\n');
    fprintf(fid, '\n');


%% write set up and tear down methods
function loc_writeSetup(fid)

    % write setup and tear down function
    fprintf(fid, '%%%% fun: setup unit test\n');
    fprintf(fid, '    function set_up %%#ok\n');
    fprintf(fid, '        warning(''off'', ''all'');\n\n');
    fprintf(fid, '%%%% fun: tear down unit test\n');
    fprintf(fid, '    function tear_down %%#ok\n');
    fprintf(fid, '        warning(''on'', ''all'');\n');
    
    
%% write predefined test functions
function loc_writeTestFun(fid, s_funName)

    % write a default failed test 
    fprintf(fid, '\n%%%% test: test for %s\n', s_funName);
    fprintf(fid, '    function test_%s %%#ok\n\n',s_funName);
    fprintf(fid, '        %% test: default fail\n');
    fprintf(fid, '        expected = 1;\n');
    fprintf(fid, '        assert_equals(expected,0);\n\n');
    