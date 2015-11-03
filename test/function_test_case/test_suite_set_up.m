%Test suite_set_up and suite_tear_down in function test cases.
%  Lack of suite_set_up functions need not be tested, because evident in the other tests.

%  $Id$

function test = test_suite_set_up %#ok<STOUT>

output_tests_from_mfile;
loc_capsule('');


function suite_set_up  %#ok

    assert_equals('', loc_capsule());
    loc_capsule('started');


function suite_tear_down %#ok

    assert_equals('ended', loc_capsule());

function test_one %#ok

    loc_progress_state();


function out = loc_capsule(in)

    persistent state;
    if isempty(state)
        state = '';
    end

    if nargin==1
        state = in;
    end
    
    out = state;


function loc_progress_state()

    switch loc_capsule
    case 'started'
        loc_capsule('ended');
    otherwise
        mlunit_fail('Expected ''started'', but got ''%s''.', loc_capsule);
    end
