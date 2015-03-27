function test = test_assert_equals

test = load_tests_from_mfile(test_loader);


function test_equals_on_empty

   double_test_equal_arguments([], []);
   double_test_equal_arguments('', '');
   double_test_equal_arguments({}, {});
   double_test_equal_arguments(struct([]), struct([]));


function test_equals_array

   double_test_equal_arguments(3, [3]);
   m = magic(5);
   double_test_equal_arguments(m, m);


function test_equals_mixed_input

   % char and numeric often compare to equal
   double_test_equal_arguments([], '');
   double_test_equal_arguments([65], 'A');


function test_equals_string

   s = ['hello';'world'];
   double_test_equal_arguments(s, s);


function test_equals_cell

   double_test_equal_arguments({3}, {3});
   double_test_equal_arguments({'ho'}, {'ho'});


function test_equals_struct

   s = struct('a', {42});
   double_test_equal_arguments(s, s);


function test_equals_complex

   c = cell(2);
   c{1} = [42 23];
   c{2} = 4+3i;
   c{3} = 'hello';
   c{4} = struct('a', {{'hi', 'ho'}}, 'b', {[3 4]});
   double_test_equal_arguments(c, c);


function test_equals_eps

   double_test_equal_arguments(0.3, 0.1+0.2, eps(0.3));
   double_test_equal_arguments(0.3, 0.31, 0.01 + eps(0.3));
   double_test_equal_arguments(0.5, 0.25, 0.25);


% helper for asserting assert_equals to succeed and assert_not_equals to fail
function double_test_equal_arguments(varargin)

   assert_equals(varargin{:});
   assert_error(@() assert_not_equals(varargin{:}));

   
function test_equals_object

    % construct a timeseries object for comparison
    t = timeseries(1:12);
    assert_equals(t, t);


function test_equals_handle

    % 0 is the root graphic object's handle, always present
    h = 0;
    assert_true(ishandle(h));
    assert_equals(h, h);


function test_equals_functionhandle

    fh = @(x) x*x+x;
    assert_true(isa(fh, 'function_handle'));
    assert_equals(fh, fh);


function test_equals_javaobject

    % apparently, MATLAB's isequal internally delegates to Java Objects' equals
    % method, making two different objects containing the same string equal
    % consider Java's == operator in comparison
    jo = java.lang.String('hiho');
    jo2 = java.lang.String('hiho');
    assert_equals(jo, jo2);


% Test equality on a Simulink.ModelWorkspace object, which seems to be a special
% type of object. Needs Simulink installed.
function test_equals_object_SimulinkModelWorkspace

    sysname = 'fuelsys';
    [was_loaded, workspace] = loc_getModelWorkspace(sysname);

    % We need to examine the Simulink.ModelWorkspace in a hot state, i.e. with
    % the model still loaded. We want to make sure to close the system
    % afterwards, if it was not loaded already. Therefore, we have to
    % temporarily catch any assert_equals errors and rethrow them only after we
    % closed the system.
    err = struct([]);
    try
        assert_equals(workspace, workspace);
    catch
        err = lasterror;
    end
    
    if ~was_loaded
        close_system(sysname, 0);
    end

    if ~isempty(err)
        rethrow(err);
    end

% Load a specific model, query its ModelWorkspace parameter and leave it open.    
function [loaded_initially, mdlWorkspace] = loc_getModelWorkspace(sysname)

    isloaded = @(sysname) ~isempty(find_system('Name', sysname, 'Parent', ''));
    loaded_initially = isloaded(sysname);
    
    load_system(sysname);
    mdlWorkspace = get_param(sysname, 'ModelWorkspace');
