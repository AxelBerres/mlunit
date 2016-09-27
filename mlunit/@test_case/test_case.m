function self = test_case(name, function_name)
%Base class for a test suite.
%  Inherit your class-based test suite from this base class. Fixture methods
%  (set_up and tear_down) get inherited or overloaded. You should not overload
%  methods named 'get_function_name', 'get_name', or 'str'.
%
%  Upon execution, for every test method, a distinct test_case object will be
%  instanciated, receiving the test method's name in the 'name' argument. This
%  is tricky to behold: Your test_case child class contains several test_
%  methods, but is instanciated over and again separately for every one of them.
%  If no name is passed, the method 'run_test' is called.
%
%  Class Info / Example
%  ====================
%  The class test_case is the base class for all tests. It defines a 
%  fixture to run multiple tests. The constructor is called as follows:
%         Example: test = test_case('test_foo');
%  test_foo is the name of the test method, my_test is the name of a
%  subclass of test_case. Such a class is created as follows:
%
%  1) Implement a subclass of test_class with a constructor looking like
%     this:
%         function self = my_test(name)
%
%         test = test_case(name, 'my_test');
%         self.dummy = 0;
%         self = class(self, 'my_test', test);
%
%  2) Define instance variables like self.dummy.
%
%  3) Override set_up to initialize the fixture.
%
%  4) Override tear_down to clean-up after a test.
%
%  5) Implement a method for each test looking like:
%         function self = test_foo(self)
%
%         assert_equals(1, mod(4 * 4, 3));
%
%  6) Run the test:
%         test = my_test('test_foo');
%         [test, result] = run(test);
%         summary(result)
%
%  See also TEST_RESULT, TEST_SUITE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id$

mlunit_narginchk(1,2,nargin);
if ~ischar(name), error('name need be char'); end
if isempty(name), error('name must not be empty'); end

% function_name argument not given, default to name
% This will mainly hit for class-based test cases deriving directly from
% test_case. function_test_case based cases set this argument
if nargin < 2, function_name = name; end

self.name = name;
self.function_name = function_name;

self = class(self, 'test_case');
