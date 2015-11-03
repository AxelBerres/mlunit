%Test is_failure functionality.
%
%  See is_failure

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function test = test_is_failure %#ok<STOUT>

output_tests_from_mfile;


function test_failure

    assert_true(is_failure(loc_failure(true)));

function test_non_failure

    assert_false(is_failure(loc_failure(false)));

    
% return the filtered given stack or the filtered default stack
function errorinfo = loc_failure(isfailure)

    % dummy errorinfo instance
    errstruct = struct();
    errstruct.message = '';
    if isfailure
        errstruct.identifier = 'MLUNIT:Failure';
    end
    errorinfo = mlunit_errorinfo(errstruct);
