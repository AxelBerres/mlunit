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
%     'abbrev_trace' - Logical true lets stack trace items display only their
%                      file name, omitting the directory path. Defaults to true.
%                      Can be mixed with linked_trace to display linked absolute
%                      trace paths.
%     'verbose'      - Logical false displays errors and failures only.
%                      Defaults to false. Logical true also displays successful
%                      test cases. Use for debugging.
%     'catch_output' - Logical true catches the console output of test functions
%                      and of set_up and tear_down fixtures. These are then
%                      included separately in the jUnit report.
%                      Defaults to false, but is set to true in the Ant build.xml.
%                      Logical false will mix mlUnit output and test output on
%                      MATLAB console.
%                      suite_set_up and suite_tear_down are never caught, because
%                      we cannot display it. All currently used jUnit displays
%                      omit testsuite-level system-out content.
%     'mark_testphase' Logical true prepends caught test output with markers
%                      indicating the output origin: [setup], [test], [tdown].
%                      Logical false does not. Requires 'catch_output' of true.
%     'all_variations_skip' Logical true skips a test if all variations were
%                      skipped using mlunit_skip_variation. Doesn't affect
%                      anything if the test doesn't use variations or if no
%                      variations were generated. Use this to control skip
%                      behaviour when you mix variations and normal assertions in
%                      the same test. Defaults to false, in which case
%                      the test succeeds, even if all variations were skipped.
%
%  VALL = MLUNIT_PARAM() returns all of the currently set mlunit parameters,
%  as a structure. The structure's fields will represent name of parameters,
%  cleaned by genvarname().
%  
%  VALL = MLUNIT_PARAM(VNEW) sets mlunit's parameter configuration to that of
%  VNEW, returning the previous parameter configuration in VALL.
%
%  MLUNIT_PARAM('-mlock') calls mlock in order to lock mlunit_param' internal
%  persistent state. MATLAB does not allow mlock to be called from anywhere
%  else, and we can not just mlock it upon every mlunit_param call.
%  Therefore, this is an extra invocation.
%

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function outvalue = mlunit_param(name, invalue)

    % get and initialize parameters
    persistent parameters;
    if isempty(parameters)
        parameters = default_values();
    end

    % usage for whole parameters structure
    if nargin == 0 || isstruct(name)
        % return parameters before setting their new value
        outvalue = parameters;
        % set new structure
        if nargin >= 1
            parameters = merge_default_values(name);
        end
        return;
    end
    
    % usage for locking mlunit_param
    if ischar(name) && strcmp(name, '-mlock')
        mlock;
    end

    % usage for single parameters
    if isvarname(name)
        clean_name = name;
    else
        clean_name = genvarname(name);
    end

    % return single parameter value before its new value is set
    if isfield(parameters, clean_name)
        outvalue = parameters.(clean_name);
    else
        % this branch should not activate since we inject default values
        % earlier in the process; nevertheless, retain it as fail-safe
        outvalue = default_value(name);
    end

    % set value
    if nargin >= 2
        parameters.(clean_name) = invalue;
    end


% Return structure with only default values.
function defaults = default_values

    defaults = struct();

    defaults.equal_nans = false;
    defaults.linked_trace = true;
    defaults.abbrev_trace = true;
    defaults.verbose = false;
    defaults.catch_output = false;
    defaults.mark_testphase = true;
    defaults.all_variations_skip = false;


function value = default_value(name)

    defaults = default_values;
    if ismember(name, fieldnames(defaults))
        value = defaults.(name);
    else
        value = [];
    end


% Complement a parameter structure with default values for mlUnit-known fields.
function parameters = merge_default_values(parameters)

    % guard against [] being given
    if isempty(parameters)
        parameters = struct();
    end

    defaults = default_values;
    missing_presets = setdiff(fieldnames(default_values), fieldnames(parameters));
    for f=1:numel(missing_presets)
        parameters.(missing_presets{f}) = defaults.(missing_presets{f});
    end
