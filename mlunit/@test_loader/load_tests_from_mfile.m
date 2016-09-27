function suite = load_tests_from_mfile(self) %#ok<INUSL>
%test_loader/load_tests_from_mfile returns a test_suite with all
%test* methods from a .m-file.
%DEPRECATED. Retained for backward compatibility for existing projects. As of
%R2015b, it is recommended to use output_tests_from_mfile instead.
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
%  $Id$

mlunit_narginchk(1,1,nargin);

stack = dbstack;
names = get_subfunction_names(self, stack(2).file);

handles = cell(size(names));
for i=1:numel(names)
    handle_retriever = evalin('caller', ['@() @', names{i}]);
    handles{i} = handle_retriever();
end

suite = build_testsuite_object(self, stack(2).name, handles);

% if exactly two items on stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
suitename = stack(2).name;
if numel(stack) == 2
    suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
    run_suite_collection(suite_runner, suitename);
end
