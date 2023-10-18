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

    % Load two different models, query the ModelWorkspace parameter and leave them open.
    syshandle(1) = new_system();
    syshandle(2) = new_system();
    ws1 = get_param(syshandle(1), 'ModelWorkspace');
    ws2 = get_param(syshandle(2), 'ModelWorkspace');
    
    % We need to examine the Simulink.ModelWorkspace in a hot state, i.e. with
    % the model still loaded. Close it only afterwards, but in any case.
    close_system_hook(1) = onCleanup(@() close_system(syshandle(1), 0));
    close_system_hook(2) = onCleanup(@() close_system(syshandle(2), 0));
    assert_not_equals(ws1, ws2);
