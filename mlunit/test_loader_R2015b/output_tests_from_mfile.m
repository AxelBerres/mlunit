%Build a test_suite with all test* methods from a .m-file.
%
%  DEPRECATED. This function was used to let mlUnit access the
%  subfunctions of a function test suite on MATLAB release R2015b. However, with
%  R2016b this did not work anymore. Instead, use the old mechanism again, which
%  is now fit to work an all MATLAB releases (up to R2016b).
%  
%  In the main function of your function test suite, call:
%       
%      test = load_tests_from_mfile(test_loader);
%
%  This approach needed to be a script rather than a function,
%  in order to obtain the subfunction handles, which, from R2015b on,
%  only works if executed from within the function test suite file.
%  However, from R2016b on, scripts will fail, too.
%
%  See also FUNCTION_TEST_CASE, TEST_LOADER.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

call_stack = dbstack;

% Contracted version of:
%   names = get_subfunction_names(test_loader, call_stack(2).file);
%   handles = get_subfunction_handles(self, stack(2).file, names);
%   test = build_testsuite_object(test_loader, call_stack(2).name, handles);
% There are always at least two items on the call stack.
if 5 == exist('getArrayFromByteStream', 'builtin')
    test = build_testsuite_object(test_loader, call_stack(2).name, get_subfunction_handles(test_loader, call_stack(2).file, get_subfunction_names(test_loader, call_stack(2).file)));
else
    test = build_testsuite_object(test_loader, call_stack(2).name, cellfun(@str2func, get_subfunction_names(test_loader, call_stack(2).file), 'UniformOutput', false));
end

% if exactly two items on call_stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
if numel(call_stack) == 2
    run_suite_collection(add_listener(mlunit_suite_runner, mlunit_progress_listener_console), call_stack(2).name);
end
