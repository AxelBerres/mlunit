function suite = load_tests_from_mfile(self, includeNames, excludeNames) %#ok<INUSL>
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
    if ~iscellstr(includeNames) && (~ischar(includeNames) || ~strcmpi('skip', includeNames))
        error('MLUNIT:inputString', 'When giving 3 arguments, the second argument must either be a cellstr array, or the string ''skip''.');
    end
    if ~iscellstr(excludeNames)
        error('MLUNIT:inputCellstr', 'When giving 3 arguments, the third argument, EXCLUDES must be a cellstr array.');
    end
    excludes = excludeNames;
end

includes = {};
includeAll = true;
if nargin >= 2
    if ~iscellstr(includeNames)
        error('MLUNIT:inputCellstr', 'When giving 2 arguments, the second argument, INCLUDES must be a cellstr array.');
    end
    includes = includeNames;
    includeAll = false;
end

stack = dbstack;
% There are always at least two items on the call stack.
names = get_subfunction_names(self, stack(2).file);

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

if ~includeAll
   excludes = union(excludes, setdiff(names, includes));
end

suitename = stack(2).name;
suite = build_testsuite_object(self, suitename, handles, excludes);

% if exactly two items on stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
if numel(stack) == 2
    suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
    run_suite_collection(suite_runner, suite);
end
