function self = set_up(self)

name = get_name(self.test_case);
test_name_contains = @(q) ~isempty(strfind(name, q));

if test_name_contains('set_up_assert')
    mlunit_fail('This is an assert_* call in set_up.');
end

if test_name_contains('set_up_error')
    error('This is a runtime error in set_up.');
end

if test_name_contains('set_up_skip')
    mlunit_skip('This is a runtime skip request in set_up.');
end
