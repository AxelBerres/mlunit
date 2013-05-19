function self = test_fail(self)
%test_assert/test_fail tests invalid assertions.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_fail'');');
%
%  See also ASSERT_TRUE, ASSERT_EQUALS, ASSERT_NOT_EQUALS.

%  �Author: Thomas Dohmke <thomas@dohmke.de> �
%  $Id: test_fail.m 269 2007-04-02 19:54:39Z thomi $

failed = 0;

% Without message
try
    assert_true(0);
    fprintf(1, 'assert(0) fails to fail.');
catch
end;

try
    assert_true(false);
	failed = 1;
catch
end;
assert_true(failed == 0, 'assert(false) fails to fail.');

% With message
try
    assert_true(false, 'Assertion must fail.');
catch
    assert_true(~isempty(strfind(lasterr, 'Assertion must fail.')));
end;

% Equals
try
    assert_equals(0, 1);
    failed = 1;
catch
end;
assert_true(failed == 0, 'assert_equals(0, 1) fails to fail.');

% Not equals
try
    assert_not_equals(1, 1);
    failed = 1;
catch
end;
assert_true(failed == 0, 'assert_not_equals(1, 1) fails to fail.');
