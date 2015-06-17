function test = test_fail
%test_assert/test_fail tests invalid assertions.
%
%  Example
%  =======
%         run(mlunit_gui, 'test_fail');
%
%  See also ASSERT_TRUE, ASSERT_EQUALS, ASSERT_NOT_EQUALS.

%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_fail.m 269 2007-04-02 19:54:39Z thomi $

test = load_tests_from_mfile(test_loader);


function test_numeric_false_without_message

failed = true;
try
    assert_true(0);
    failed = false;
catch
end;
assert_true(failed, 'assert_true(0) fails to fail.');


function test_logical_false_without_message

failed = true;
try
    assert_true(false);
    failed = false;
catch
end;
assert_true(failed, 'assert_true(false) fails to fail.');


function test_logical_false
% With message
try
    assert_true(false, 'Assertion must fail.');
catch
    assert_true(~isempty(strfind(lasterr, 'Assertion must fail.')));
end;


function test_assert_equals_fail
% Equals
failed = true;
try
    assert_equals(0, 1);
    failed = false;
catch
end;
assert_true(failed, 'assert_equals(0, 1) fails to fail.');


function test_assert_not_equals_fail
% Not equals
failed = true;
try
    assert_not_equals(1, 1);
    failed = false;
catch
end;
assert_true(failed, 'assert_not_equals(1, 1) fails to fail.');
