%Test stack expansion functionality.
%  For runtime errors, 
%
%  See is_failure

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function test = test_smoke_stackexpansion

test = load_tests_from_mfile(test_loader);


function test_stackexpansion_runtime

    stack = loc_catch_error('fullfile');
    % uppermost stack item is fullfile
    % because this error type includes stack info in the message
    assert_equals('fullfile', stack(1).name);

function test_stackexpansion_runtime_without

    stack = loc_catch_error('error');
    % uppermost stack item is loc_catch_error, not error
    % because this error type does not include stack info in the message
    assert_equals('loc_catch_error', stack(1).name);

function test_stackexpansion_syntax

    stack = loc_catch_error('syntax_error_ifend');
    % uppermost stack item is syntax_error_ifend
    % because this error type includes stack info in the message
    assert_equals('syntax_error_ifend', stack(1).name);

function test_stackexpansion_syntax_without

    stack = loc_catch_error('error(');
    % uppermost stack item is loc_catch_error
    % because this error type does not include stack info in the message
    assert_equals('loc_catch_error', stack(1).name);


function stack = loc_catch_error(evalstring)

    einfo = [];

    try
        eval(evalstring);
    catch
        einfo = mlunit_errorinfo(lasterror);
    end

    assert_not_empty(einfo);

    stack = loc_get_message_with_stack_clone(einfo);


function stack = loc_get_message_with_stack_clone(self)

    % obtain message and stack
    [message, stack] = filter_lasterror_wraps(self);

    % reduce the stack of failures for better overview
    if is_failure(self)
        stack = filter_failure_stack(self, stack);
    end
