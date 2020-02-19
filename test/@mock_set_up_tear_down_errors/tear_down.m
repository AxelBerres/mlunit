function self = tear_down(self)

test_name_contains = @(q) ~isempty(strfind(get_name(self.test_case), q));

if test_name_contains('tear_down_assert')
    mlunit_fail('This is an assert_* call in tear_down.');
end

if test_name_contains('tear_down_error')
    error('This is a runtime error in tear_down.');
end

if test_name_contains('tear_down_skip')
    mlunit_skip('This is a runtime skip request in tear_down.');
end
