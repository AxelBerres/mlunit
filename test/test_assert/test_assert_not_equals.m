function test = test_assert_not_equals %#ok<STOUT>

output_tests_from_mfile;


function test_not_equals

   double_test_different_arguments(3, {3});


function test_not_equals_on_empty

   double_test_different_arguments([], 3);
   double_test_different_arguments('', 3);
   double_test_different_arguments({}, 3);
   double_test_different_arguments(struct([]), 3);


function test_not_equals_eps

   % not equal because eps too small
   double_test_different_arguments(0.3, 0.31, 0.0099);


% helper for asserting assert_not_equals to succeed and assert_equals to fail
function double_test_different_arguments(varargin)

   assert_not_equals(varargin{:});
   assert_error(@() assert_equals(varargin{:}));


function test_not_equals_inf

    assert_not_equals(Inf, -Inf);
    assert_not_equals(Inf, -Inf, 0.1);
    assert_not_equals({Inf}, {-Inf});


function test_not_equals_object

    % construct a timeseries object for comparison
    t = timeseries(1:12);
    t2 = t;
    d = get(t2, 'Data');
    d(12) = 13;
    set(t2, 'Data', d);
    assert_not_equals(t, t2);


function test_not_equals_handle

    % 0 is the root graphic object's handle, always present
    h = 0;
    f = figure();
    
    assert_true(ishandle(h));
    assert_true(ishandle(f));
    
    % temporarily catch any assert_not_equals errors and rethrow them only after
    % we closed the figure
    err = struct([]);
    try
        assert_not_equals(h, f);
    catch
        err = lasterror;
    end
    
    close(f);
    if ~isempty(err)
        rethrow(err)
    end


function test_not_equals_functionhandle

    fh1 = @(x) x*x+x;
    fh2 = @(x) x+x*x;
    assert_true(isa(fh1, 'function_handle'));
    assert_true(isa(fh2, 'function_handle'));
    assert_not_equals(fh1, fh2);


function test_not_equals_javaobject

    jo = java.lang.String('hiho');
    jo2 = java.lang.String('hiHo');
    assert_not_equals(jo, jo2);


% Test equality on a Simulink.ModelWorkspace object, which seems to be a special
% type of object. Needs Simulink installed.
function test_not_equals_object_SimulinkModelWorkspace

    s1 = 'sldemo_fuelsys';
    s2 = 'busdemo';
    [wasloaded_s1, ws_s1] = loc_getModelWorkspace(s1);
    [wasloaded_s2, ws_s2] = loc_getModelWorkspace(s2);

    % We need to examine the Simulink.ModelWorkspace in a hot state, i.e. with
    % the model still loaded. We want to make sure to close the system
    % afterwards, if it was not loaded already. Therefore, we have to
    % temporarily catch any assert_equals errors and rethrow them only after we
    % closed the system.
    err = struct([]);
    try
        assert_not_equals(ws_s1, ws_s2);
    catch
        err = lasterror;
    end
    
    if ~wasloaded_s1, close_system(s1, 0); end
    if ~wasloaded_s2, close_system(s2, 0); end

    if ~isempty(err)
        rethrow(err);
    end

% Load a specific model, query its ModelWorkspace parameter and leave it open.    
function [loaded_initially, mdlWorkspace] = loc_getModelWorkspace(sysname)

    isloaded = @(sysname) ~isempty(find_system('Name', sysname, 'Parent', ''));
    loaded_initially = isloaded(sysname);
    
    load_system(sysname);
    mdlWorkspace = get_param(sysname, 'ModelWorkspace');
