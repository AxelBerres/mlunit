%Test filter_lasterror_wraps functionality.
%
%  See filter_lasterror_wraps.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function test = test_filter_lasterror

test = load_tests_from_mfile(test_loader);
    

function test_empty_message

    assert_equals('(no message available)', loc_parse_error(''));
    
function test_omit_if_already_clean

    % don't parse already cleaned messages
    msg_clean = 'This statement is incomplete.';
    assert_equals(msg_clean, loc_parse_error(msg_clean));
    
    % don't parse already cleaned messages
    msg_clean = 'Expression or statement is incorrect--possibly unbalanced (, {, or [.';
    assert_equals(msg_clean, loc_parse_error(msg_clean));
    
function test_omit_if_clean_but_similar

    msg_clean = 'Error using something.';
    assert_equals(msg_clean, loc_parse_error(msg_clean));

% call 'error()' in a function
function test_runtime_error_a_R2006b
    
    % lasterror.message format on R2006b, R2007b, R2010b
    % Error using ==> error
    % Not enough input arguments.
    expected_msg = 'Not enough input arguments.';
    msg_R2006b = sprintf('%s\n%s', 'Error using ==> error', 'Not enough input arguments.');
    assert_equals(expected_msg, loc_parse_error(msg_R2006b));

% call 'error()' in a function
function test_runtime_error_a_R2011b
    
    % lasterror.message format on R2011b, R2013b
    % Error using <a href="matlab:helpUtils.errorDocCallback(''error'')" style="font-weight:bold">error</a>
    % Not enough input arguments.
    expected_msg = 'Not enough input arguments.';
    msg_R2011b = sprintf('%s\n%s', 'Error using <a href="matlab:helpUtils.errorDocCallback(''error'')" style="font-weight:bold">error</a>', 'Not enough input arguments.');
    assert_equals(expected_msg, loc_parse_error(msg_R2011b));
    
% call 'error(''foo'')' in a function
function test_runtime_error_b_R2006b

    % Error using ==> demo_runtime_error
    % foo
    expected_msg = 'foo';
    errmsg = sprintf('%s\n%s', 'Error using ==> demo_runtime_error', 'foo');
    assert_equals(expected_msg, loc_parse_error(errmsg));

% call 'error(''foo'')' in a function
function test_runtime_error_b_R2007b

    % Error using ==> <a href="error:C:\Users\Hetu\Links\Favorites\Documents\MATLAB\demo_runtime_error.m,3,0">demo_runtime_error at 3</a>
    % foo
    expected_msg = 'foo';
    errmsg = sprintf('%s\n%s', 'Error using ==> <a href="error:C:\Users\Hetu\Links\Favorites\Documents\MATLAB\demo_runtime_error.m,3,0">demo_runtime_error at 3</a>', 'foo');
    assert_equals(expected_msg, loc_parse_error(errmsg));

% call 'error(''foo'')' in a function
function test_runtime_error_b_R2010b

    % Error using ==> <a href="matlab: opentoline(''C:\Dokumente und Einstellungen\hetu\Eigene Dateien\MATLAB\demo_runtime_error.m'',3,0)">demo_runtime_error at 3</a>
    % foo
    expected_msg = 'foo';
    errmsg = sprintf('%s\n%s', 'Error using ==> <a href="matlab: opentoline(''C:\Dokumente und Einstellungen\hetu\Eigene Dateien\MATLAB\demo_runtime_error.m'',3,0)">demo_runtime_error at 3</a>', 'foo');
    assert_equals(expected_msg, loc_parse_error(errmsg));

% call 'error(''foo'')' in a function
function test_runtime_error_b_R2011b

    % Error using <a href="matlab:helpUtils.errorDocCallback(''demo_runtime_error'', ''C:\Users\Hetu\Documents\MATLAB\demo_runtime_error.m'', 3)" style="font-weight:bold">demo_runtime_error</a> (<a href="matlab: opentoline(''C:\Users\Hetu\Documents\MATLAB\demo_runtime_error.m'',3,0)">line 3</a>)
    % foo
    expected_msg = 'foo';
    errmsg = sprintf('%s\n%s', 'Error using <a href="matlab:helpUtils.errorDocCallback(''demo_runtime_error'', ''C:\Users\Hetu\Documents\MATLAB\demo_runtime_error.m'', 3)" style="font-weight:bold">demo_runtime_error</a> (<a href="matlab: opentoline(''C:\Users\Hetu\Documents\MATLAB\demo_runtime_error.m'',3,0)">line 3</a>)', 'foo');
    assert_equals(expected_msg, loc_parse_error(errmsg));

% call 'error(' in a function
function test_syntax_error_R2006b

    % lasterror.message format on R2006b
    % Error: <a href="error:C:\Programme\MATLAB\R2006b\work\demo_syntax_error.m,3,7">File: demo_syntax_error.m Line: 3 Column: 7</a>
    % This statement is incomplete.
    expected_msg = 'This statement is incomplete.';
    msg_R2006b = sprintf('%s\n%s', 'Error: <a href="error:C:\Programme\MATLAB\R2006b\work\demo_syntax_error.m,3,7">File: demo_syntax_error.m Line: 3 Column: 7</a>', 'This statement is incomplete.');
    assert_equals(expected_msg, loc_parse_error(msg_R2006b));

% call 'assert_equals(0, 1))'
function test_syntax_error_R2007b_without_link

    % lasterror.message format on R2007b 64-bit, when being executed on some
    % strange environment, like Windows 8 with -automation -nosplash -nodesktop
    % Error: File: c:\Program Files (x86)\Jenkins\jobs\mlUnit single\workspace\test\@mock_test\test_unbalanced_parentheses.m Line: 14 Column: 20
    % Unbalanced or unexpected parenthesis or bracket.
    expected_msg = 'Unbalanced or unexpected parenthesis or bracket.';
    msg_R2007b = sprintf('%s\n%s', 'Error: File: c:\Program Files (x86)\Jenkins\jobs\mlUnit single\workspace\test\@mock_test\test_unbalanced_parentheses.m Line: 14 Column: 20', 'Unbalanced or unexpected parenthesis or bracket.');
    assert_equals(expected_msg, loc_parse_error(msg_R2007b));
    
% call 'error(' in a function
function test_syntax_error_R2007b_msg_and_stack
    
    % lasterror.message format on R2007b
    % Error: <a href="error:C:\Users\Hetu\Links\Favorites\Documents\MATLAB\demo_syntax_error.m,4,7">File: demo_syntax_error.m Line: 4 Column: 7</a>
    % Expression or statement is incorrect--possibly unbalanced (, {, or [.
    expected_msg = 'Expression or statement is incorrect--possibly unbalanced (, {, or [.';
    msg_R2007b = sprintf('%s\n%s', 'Error: <a href="error:C:\Users\Hetu\Links\Favorites\Documents\MATLAB\demo_syntax_error.m,4,7">File: demo_syntax_error.m Line: 4 Column: 7</a>', 'Expression or statement is incorrect--possibly unbalanced (, {, or [.');
    [actual_msg, actual_stack] = loc_parse_error(msg_R2007b);
    assert_equals(expected_msg, actual_msg);
    assert_true(numel(actual_stack) >= 1);
    assert_equals(4, actual_stack(1).line);
    assert_equals('demo_syntax_error', actual_stack(1).name);

% call 'error(' in a function
function test_syntax_error_R2010b
    
    % lasterror.message format on R2010b
    % Error: <a href="matlab: opentoline(''C:\Dokumente und Einstellungen\hetu\Eigene Dateien\MATLAB\demo_syntax_error.m'',2,7)">File: demo_syntax_error.m Line: 2 Column: 7</a>
    % This statement is incomplete.
    expected_msg = 'This statement is incomplete.';
    msg_R2010b = sprintf('%s\n%s', 'Error: <a href="matlab: opentoline(''C:\Dokumente und Einstellungen\hetu\Eigene Dateien\MATLAB\demo_syntax_error.m'',2,7)">File: demo_syntax_error.m Line: 2 Column: 7</a>', 'This statement is incomplete.');
    assert_equals(expected_msg, loc_parse_error(msg_R2010b));

% call 'error(' in a function
function test_syntax_error_R2011b
    
    % lasterror.message format on R2011b
    % Error: <a href="matlab: opentoline(''C:\Users\hetu\Documents\MATLAB\demo_syntax_error.m'',5,7)">File: demo_syntax_error.m Line: 5 Column: 7</a>
    % Expression or statement is incorrect--possibly unbalanced (, {, or [.
    expected_msg = 'Expression or statement is incorrect--possibly unbalanced (, {, or [.';
    msg_R2011b = sprintf('%s\n%s', 'Error: <a href="matlab: opentoline(''C:\Users\hetu\Documents\MATLAB\demo_syntax_error.m'',5,7)">File: demo_syntax_error.m Line: 5 Column: 7</a>', 'Expression or statement is incorrect--possibly unbalanced (, {, or [.');
    assert_equals(expected_msg, loc_parse_error(msg_R2011b));

% call 'error(' in a function
function test_syntax_error_R2013b
    
    % lasterror.message format on R2013b
    % Error: <a href="matlab: opentoline(''C:\Users\hetu\Documents\MATLAB\demo_syntax_error.m'',5,7)">File: demo_syntax_error.m Line: 5 Column: 7
    % </a>Expression or statement is incorrect--possibly unbalanced (, {, or [.
    expected_msg = 'Expression or statement is incorrect--possibly unbalanced (, {, or [.';
    msg_R2013b = sprintf('%s\n%s', 'Error: <a href="matlab: opentoline(''C:\Users\hetu\Documents\MATLAB\demo_syntax_error.m'',5,7)">File: demo_syntax_error.m Line: 5 Column: 7', '</a>Expression or statement is incorrect--possibly unbalanced (, {, or [.');
    assert_equals(expected_msg, loc_parse_error(msg_R2013b));

function test_default_stack

    [dummy, stack] = loc_parse_error('foobar');
    assert_empty(stack);
    
function [parsed_message, stack] = loc_parse_error(message)

    errstruct = struct();
    errstruct.message = message;
    errorinfo = mlunit_errorinfo(errstruct);
    [parsed_message, stack] = filter_lasterror_wraps(errorinfo);
