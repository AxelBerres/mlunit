function suite = load_tests_from_mfile(self) %#ok
%test_loader/load_tests_from_mfile returns a test_suite with all
%test* methods from a .m-file.
%
%  Example
%  =======
%  load_tests_from_mfile is called from within the .m-file, that contains
%  the test* methods, e.g:
%         function test = test_example
%
%         test = load_tests_from_mfile(test_loader);
%
%             function test_method
%                 assert_true(0 == sin(0));
%             end
%         end
%
%  See also FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: load_tests_from_mfile.m 173 2012-06-12 09:26:53Z alexander.roehnsch $

error(nargchk(1,1,nargin,'struct'));

stack = dbstack;

str = textread(stack(2).file, '%s', 'whitespace', '', 'delimiter', '\n' );
idx = regexp(str, '^\s*function\s+\w*', 'start');
is_func = not(cellfun('isempty', idx));

% remove very first function item, which should be the host function
is_func(find(is_func, 1)) = 0;

tokens = transpose(regexp(str(is_func),...
    '^\s*function\s+(\w*)\s*\%*.*',...
    'tokens'));

set_up_handle = 0;
tear_down_handle = 0;

% suite setup and teardown need not necessarily be set, therefore use
% test_case's implementation by default, and overwrite only if present
suite_setup_obj = function_test_case(0,0,0,'');
suite_teardown_obj = function_test_case(0,0,0,'');

for token = tokens
    fun = token{1}{:};
    if (strcmp(fun, 'set_up'))
        set_up_handle = evalin('caller', ['@() @', char(fun)]);
        set_up_handle = set_up_handle();
    end;
    if (strcmp(fun, 'tear_down'))
        tear_down_handle = evalin('caller', ['@() @', char(fun)]);
        tear_down_handle = tear_down_handle();
    end;
    if (strcmp(fun, 'suite_set_up'))
        suite_set_up_handle = evalin('caller', ['@() @', char(fun)]);
        suite_set_up_handle = suite_set_up_handle();
        suite_setup_obj = function_test_case(...
            suite_set_up_handle, ...
            0, ...
            0, ...
            'suite_set_up');
    end
    if (strcmp(fun, 'suite_tear_down'))
        suite_tear_down_handle = evalin('caller', ['@() @', char(fun)]);
        suite_tear_down_handle = suite_tear_down_handle();
        suite_teardown_obj = function_test_case(...
            suite_tear_down_handle, ...
            0, ...
            0, ...
            'suite_tear_down');
    end
end;

% if exactly two items on stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
suitename = stack(2).name;
if numel(stack) == 2
    suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
    run_suite_collection(suite_runner, suitename);
end

suite = mlunit_testsuite(stack(2).name, suite_setup_obj, suite_teardown_obj);
for token = tokens
    test = char(token{1}{:});
    pos = findstr('test', test);
    if (~isempty(pos) && (pos(1) == 1))
        fun_handle = evalin('caller', ['@() @', test, '']);
        fun_handle = fun_handle();
        testobj = function_test_case(...
            fun_handle,...
            set_up_handle,...
            tear_down_handle, ...
            test);
        suite = add_test(suite, testobj);
    end;
end;
