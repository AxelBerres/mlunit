function suite = build_testsuite_object(self, suitename, funs, excludes, excludeReason) %#ok<INUSL>
%Build a test_suite object from a list of handles.
%
%Looks out for special functions set_up, tear_down, suite_set_up and
%suite_tear_down and establishes bindings accordingly.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

mlunit_narginchk(5, 5, nargin);
if ~iscell(funs) || ~all(cellfun(@(f)isa(f,'function_handle'),funs))
    error('funs need be cell array of function_handle objects');
end
if ~iscellstr(excludes)
    error('excludes need be cellstr array');
end
if ~ischar(excludesReason)
    error('excludesReason need be char array');
end

set_up_handle = 0;
tear_down_handle = 0;

% suite setup and teardown need not necessarily be set, therefore use
% test_case's implementation by default, and overwrite only if present
suite_setup_obj = function_test_case(0,0,0,'');
suite_teardown_obj = function_test_case(0,0,0,'');

for i=1:numel(funs)
    fhandle = funs{i};
    finfo = functions(fhandle);
    fname = finfo.function;
    
    switch fname
        case 'set_up'
            set_up_handle = fhandle;
        case 'tear_down'
            tear_down_handle = fhandle;
        case 'suite_set_up'
            suite_setup_obj = function_test_case(...
                fhandle, ...
                0, ...
                0, ...
                'suite_set_up');
        case 'suite_tear_down'
            suite_teardown_obj = function_test_case(...
                fhandle, ...
                0, ...
                0, ...
                'suite_tear_down');
        otherwise
            % nothing
    end
end

suite = mlunit_testsuite(suitename, suite_setup_obj, suite_teardown_obj);
for i=1:numel(funs)
    fhandle = funs{i};
    finfo = functions(fhandle);
    fname = finfo.function;
    disabled = any(strcmp(fname, excludes));

    if strncmp(fname, 'test', 4)
        testobj = function_test_case(...
            fhandle,...
            set_up_handle,...
            tear_down_handle, ...
            fname, ...
            disabled, ...
            excludeReason);
        suite = add_test(suite, testobj);
    end
end
