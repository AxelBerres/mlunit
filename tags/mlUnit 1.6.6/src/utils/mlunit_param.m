%MLUNIT_PARAM Set or get an mlunit parameter
%  MLUNIT_PARAM(P) returns the current value of mlUnit's parameter named P.
%
%  MLUNIT_PARAM(P, V) changes mlUnit behaviour across multiple test calls in the
%  same MATLAB instance. P is the name of the mlUnit parameter, V its value.
%
%  VOLD = MLUNIT_PARAM(P, V) does the same, but returns the parameter's value
%  before the change in VOLD.
%
%  List of parameters:
%     'equal_nans' - Logical true handles NaNs equal to each other in
%                    assert_equals and assert_not_equals calls. Logical false
%                    handles NaNs not equal to each other. Defaults to false.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$
function outvalue = mlunit_param(name, invalue)

    % handle usage errors
    if nargin == 0 || isempty(name)
        error('Provide the parameter name as first argument.');
    end
    
    % get and initialize parameters
    persistent parameters;
    if isempty(parameters)
        parameters = struct();
    end

    % return parameter value before its new value is set
    clean_name = genvarname(name);
    if isfield(parameters, clean_name)
        outvalue = parameters.(clean_name);
    else
        outvalue = default_value(name);
    end

    % set value
    if nargin >= 2
        parameters.(clean_name) = invalue;
    end


function value = default_value(name)

    switch name
    case 'equal_nans'
        value = false;
    otherwise
        value = [];
    end
