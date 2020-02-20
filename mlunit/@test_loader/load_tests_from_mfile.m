function suite = load_tests_from_mfile(self, explicitNames, excludeNames)
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
%             test = load_tests_from_mfile(test_loader);
%         end
%
%         function test_method
%             assert_true(0 == sin(0));
%         end
%
%  In order to disable some of the tests in the .m-file, add their names in a cellstr
%  array to load_tests_from_mfile, along with the 'skip' option.
%  The tests will show up as skipped in the reports:
%         function test = test_example
%             test = load_tests_from_mfile(test_loader, 'skip', {'test_method'});
%         end
%
%  In order to only load specific tests from the .m-file, add their names in a cellstr
%  array to load_tests_from_mfile.
%  Only those tests will show up in reports:
%         function test = test_example
%             test = load_tests_from_mfile(test_loader, {'test_method'});
%         end
%
%  See also FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the
%  GNU General Public License (GPL), see LICENSE for details.

mlunit_narginchk(1,3,nargin);

excludes = {};
if nargin >= 3
    if ~ischar(explicitNames) && ~strcmpi('skip', explicitNames)
        error('MLUNIT:inputString', 'When giving 3 arguments, the second argument, FLAG, must be the string ''skip''.');
    end
    if ~iscellstr(excludeNames)
        error('MLUNIT:inputCellstr', 'When giving 3 arguments, the third argument, EXCLUDES must be a cellstr array.');
    end
    excludes = excludeNames;
end

useExplicitNames = false;
if nargin == 2
    if ~iscellstr(explicitNames)
        error('MLUNIT:inputCellstr', 'When giving 2 arguments, the second argument, NAMES must be a cellstr array.');
    end
    useExplicitNames = true;
end

stack = dbstack;
if useExplicitNames
   names = explicitNames;
else
   % There are always at least two items on the call stack.
   names = get_subfunction_names(self, stack(2).file);
end

handles = cell(size(names));
for i=1:numel(names)
    handle_retriever = evalin('caller', ['@() @', names{i}]);
    handles{i} = handle_retriever();
end

suite = build_testsuite_object(self, stack(2).name, handles, excludes);

% if exactly two items on stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
suitename = stack(2).name;
if numel(stack) == 2
    suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
    run_suite_collection(suite_runner, suitename);
end
