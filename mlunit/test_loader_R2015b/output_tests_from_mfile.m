%Build a test_suite with all test* methods from a .m-file.
%
%Use this in a function test suite's main function in order to let mlUnit access
%its subfunctions.
%
%This needs to be a script rather than a function, in order to obtain the
%subfunction handles, which, from R2015b on, only works if executed from within
%the function test suite file.
%
%Because it is a script, its implementation is tight, i.e. tries not to drop
%temporary variables unnecessarily. The only variables created are "call_stack"
%and "test".
%
%  Example
%  =======
%  output_tests_from_mfile is called from within the .m-file that contains
%  the test* methods. The return parameter MUST be named "test":
%
%         function test = test_example
%             output_tests_from_mfile;
%         end
%
%         function test_method
%             assert_true(0 == sin(0));
%         end
%
%  See also FUNCTION_TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

call_stack = dbstack;

% Contracted version of:
%   names = get_subfunction_names(test_loader, call_stack(2).file);
%   handles = get_subfunction_handles(self, stack(2).file, names);
%   test = build_testsuite_object(test_loader, call_stack(2).name, handles);
% There are always at least two items on the call stack.
test = build_testsuite_object(test_loader, call_stack(2).name, get_subfunction_handles(test_loader, call_stack(2).file, get_subfunction_names(test_loader, call_stack(2).file)));

% if exactly two items on call_stack, that's load_tests_from_mfile and the test
% function, meaning we were called from console directly -> execute suite
if numel(call_stack) == 2
    run_suite_collection(add_listener(mlunit_suite_runner, mlunit_progress_listener_console), call_stack(2).name);
end
