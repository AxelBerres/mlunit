function suite = load_tests_from_mfile(self, explicitNames) %#ok<INUSL>
%Returns a test_suite with all test* methods from a .m-file.
%
%  This is the recommended function for loading tests from a function test
%  suite.
%
%  Compatibility: R2006b and newer
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

mlunit_narginchk(1,2,nargin);

stack = dbstack;
if nargin < 2
% There are always at least two items on the call stack.
   names = get_subfunction_names(self, stack(2).file);
else
   names = explicitNames;
end

% use direct fetch mechanism if on compatible MATLAB release
if 5 == exist('getArrayFromByteStream', 'builtin')
    handles = get_subfunction_handles(self, stack(2).file, names);
else
    % on older MATLAB releases we obtain the subfunction handles by querying
    % them on the caller's workspace
    handles = cell(size(names));
    for i=1:numel(names)
        handle_retriever = evalin('caller', ['@() @', names{i}]);
        handles{i} = handle_retriever();
    end
end

suite = build_testsuite_object(self, stack(2).name, handles);

% if exactly two items on stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
suitename = stack(2).name;
if numel(stack) == 2
    suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
    run_suite_collection(suite_runner, suitename);
end
