%MLUNIT_PARAM Set or get an mlunit parameter
%  MLUNIT_PARAM(P) returns the current value of mlUnit's parameter named P,
%  P being a string.
%
%  MLUNIT_PARAM(P, V) changes mlUnit behaviour across multiple test calls in the
%  same MATLAB instance. P is the name of the mlUnit parameter, V its value.
%
%  VOLD = MLUNIT_PARAM(P, V) does the same, but returns the parameter's value
%  before the change in VOLD.
%
%  List of parameters:
%     'equal_nans'   - Logical true handles NaNs equal to each other in
%                      assert_equals and assert_not_equals calls. Logical false
%                      handles NaNs not equal to each other. Defaults to false.
%     'linked_trace' - Logical true displays stack trace items as html links.
%                      Logical false displays them unlinked, as absolute path.
%                      Defaults to true. 
%
%  VALL = MLUNIT_PARAM() returns all of the currently set mlunit parameters,
%  as a structure. The structure's fields will represent name of parameters,
%  cleaned by genvarname().
%  
%  VALL = MLUNIT_PARAM(VNEW) sets mlunit's parameter configuration to that of
%  VNEW, returning the previous parameter configuration in VALL.
%

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$
function outvalue = mlunit_param(name, invalue)

    % get and initialize parameters
    persistent parameters;
    if isempty(parameters)
        parameters = struct();
    end

    % usage for whole parameters structure
    if nargin == 0 || isstruct(name)
        % return parameters before setting their new value
        outvalue = parameters;
        % set new structure
        if nargin >= 1
            parameters = name;
        end
        return;
    end

    % usage for single parameters
    clean_name = genvarname(name);

    % return single parameter value before its new value is set
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
    case 'linked_trace'
        value = true;
    otherwise
        value = [];
    end
