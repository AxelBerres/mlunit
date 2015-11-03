% Test find_struct_differences functionality.

% Copyright (c) 2015, mlUnit
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
%
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function test = test_find_struct_differences %#ok<STOUT>

output_tests_from_mfile;


function test_equality

    s = struct('foo', 42);
    assert_empty(find_struct_differences(s, s));
    
function test_equality_emptystruct

    s = struct('foo', {});
    assert_error(@() find_struct_differences(s, s));

function test_equality_emptystruct_nofields

    s = struct([]);
    assert_error(@() find_struct_differences(s, s));

function test_differentFieldOrder

    x = struct('a','','b','');
    y = struct('b','','a','');

    assert_empty(find_struct_differences(x, y));

function test_equalStructArrays

    x = struct('field1', {1 2}, 'field2', {'a', 'c'});
    y = struct('field1', {1 2}, 'field2', {'a', 'c'});

    assert_error(@() find_struct_differences(x, y));

function test_differentFieldnames

    x = struct('a','','b','');
    y = struct('c','','a','');
    
    result = struct( ...
        'fieldpath', {'.b', '.c'}, ...
        'missingin', {'actual', 'expected'}, ...
        'expected', {'', []}, ...
        'actual', {[], ''});

    assert_equals(result, find_struct_differences(x, y));

function test_manyDifferencesNested

    x.a = struct('a','','b','hi');
    x.b = 3;
    x.c = 'foo';
    y.a = struct('b','ho','a','','c','');
    y.c = 'bar';

    result = struct( ...
        'fieldpath', {'.b',     '.a.c',     '.a.b', '.c'}, ...
        'missingin', {'actual', 'expected', '',     ''}, ...
        'expected',  {3,        [],         'hi',   'foo'}, ...
        'actual',    {[],       '',         'ho',   'bar'});

    assert_equals(result, find_struct_differences(x, y));    


%% boilerplate code for testing functions that are private to assert functions
function set_up

    assertdir = fileparts(which('assert_error'));
    testdir = fullfile(assertdir, 'private');
    
    % buffer current path
    mlunit_param('usertest_find_struct', pwd);
    cd(testdir);

function tear_down

    % reset to previous dir
    cd(mlunit_param('usertest_find_struct'));
