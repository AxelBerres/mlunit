function self = test_case(name, subclass, function_name)
%test_case constructor.
%  The constructer creates an object of the class test_case running the 
%  test method with given name. If no name is passed, the method 
%  'run_test' is called.
%
%  Class Info / Example
%  ====================
%  The class test_case is the base class for all tests. It defines a 
%  fixture to run multiple tests. The constructor is called as follows:
%         Example: test = test_case('test_foo', 'my_test');
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

% name argument not given or empty, default to 'run_test'
if nargin < 1 || isempty(name)
   name = 'run_test';
end

% subclass argument given, reflect on it a bit
if nargin >= 2
   r = reflect(subclass);
   if (~method_exists(r, name))
      error(['Method ', name ' does not exists.']);
   end;
end

% function_name argument not given, default to ''
if nargin < 3, function_name = ''; end

self.name = name;
self.function_name = function_name;

self = class(self, 'test_case');
