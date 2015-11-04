function abstract_assert_equals(pass_if_equal, expected, actual, absolute_eps_or_msg, varargin)
%ABSTRACT_ASSERT_EQUALS Raise an error if two expressions do not compare.
%  ABSTRACT_ASSERT_EQUALS(PASS_IF_EQUAL, EXPECTED, ACTUAL)
%  raises a MATLAB error if PASS_IF_EQUALS is true and EXPECTED and ACTUAL
%  are not the same. Also raises a MATLAB error if PASS_IF_EQUALS is false
%  and EXPECTED and ACTUAL are the same.
%
%  ABSTRACT_ASSERT_EQUALS(PASS_IF_EQUAL, EXPECTED, ACTUAL, ...
%  ABSOLUTE_ESP) does the same, except if EXPECTED and ACTUAL are numeric
%  and of the same type. Then they are considered equal, if their absolute
%  difference is smaller or equal to ABSOLUTE_EPS. This works for any
%  numerics, but is incompatible with equal NaN handling.
%  
%  ABSTRACT_ASSERT_EQUALS(..., MSG, varargin) does the same, but with
%  the custom error message MSG. MSG may contain sprintf arguments, which
%  can be expanded by subsequent arguments in varargin.
%
%  See also  ASSERT_EQUALS, ASSERT_NOT_EQUALS, ASSERT_EQUALS_WITHEQUALNANS,
%  ASSERT_NOT_EQUALS_WITHEQUALNANS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

if nargin < 3, error('Not enough input arguments.'); end
if ~islogical(pass_if_equal), error('pass_if_equal must be a logical'); end

equal_nans = mlunit_param('equal_nans');

% default values for eps and message parts
absolute_eps = 0;
tolerance_msg = '';
custom_msg = '';

% Fourth argument can either be absolute_eps or msg. Handle input args carefully.
if nargin >= 4 && isnumeric(absolute_eps_or_msg)
   absolute_eps = absolute_eps_or_msg;
   % Leading dot is sentence closer for preceding message text. Closing marks
   % will be provided by message construction later on
   tolerance_msg = sprintf('. Tolerance is %s', printable(absolute_eps));
   
   % if fourth argument is eps, then the fifth may be the msg and all others the
   % msg sprintf arguments
   if nargin >= 5
      custom_msg = sprintf(varargin{1}, varargin{2:end});
   end
   
elseif nargin >= 4 && ischar(absolute_eps_or_msg)
   custom_msg = sprintf(absolute_eps_or_msg, varargin{:});
end

% needed predicates
are_classes_equal = isequal(class(expected), class(actual));
both_sizes_empty = numel(expected) == 0 && numel(actual) == 0;

% only check against eps if expected and actual both are numeric and have the
% same type, else MATLAB complains about incompatible types when using
% subtraction during eps checking later on
are_compatible_numerics = isnumeric(expected) && are_classes_equal;

% short circuit, if sizes of expected and actual differ
sizes_differ = ~isequal(size(expected), size(actual));


% determine equality
if are_classes_equal && both_sizes_empty
   equals = true;
   
% numerics of different size where at least one size is non-empty´are different
elseif are_compatible_numerics && sizes_differ
   equals = false;

% check contents only for arguments of equal size
elseif are_compatible_numerics
   
   % compare all values by default
   indices = true(size(expected));
   if equal_nans
      % select only indices for comparison where not both expected and actual
      % are NaN
      indices = ~(isnan(expected) & isnan(actual));
   end
   
   % Omit comparing equal inf values, e.g. Inf and Inf, or -Inf and -Inf,
   % because Inf arithmetic is messed up in MATLAB. Consider the results of
   % (Inf==Inf) vs. (Inf-Inf), for example.
   equalsigns = (expected < 0) == (actual < 0);
   equal_infs = isinf(expected) & isinf(actual) & equalsigns;
   indices = indices & ~equal_infs;

   % Build matrix of expected/actual differences. If at one position expected or
   % actual have a NaN, that position's difference will be NaN and fail the eps
   % test, as it should. If at one position both have a NaN, then they will have
   % been filtered before if NaNs are to be treated equal, or their difference
   % will yield a NaN as well if NaNs are to be treated different. If both have
   % an actual value other than NaN, their difference will be compared with eps
   % for real.
   diffs = expected(indices) - actual(indices);
   
   % all absolute differences must be smaller than or equal to eps
   equals = all(abs(diffs) <= absolute_eps);

% all non-numeric types, or mixed types are checked by isequal.
elseif equal_nans
   equals = isequalwithequalnans(actual, expected);
else
   equals = isequal(actual, expected);
end


% fail if pass on equal requested, but is not equal
% fail if fail on equal requested, and is equal
% else, pass quietly
if xor(pass_if_equal, equals)
    
    % construct message
    if pass_if_equal
       % In case of failed equality check, prepare special message for large scalar structs
       isscalarstruct = @(s) isstruct(s) && isscalar(s);
       if ~equals && isscalarstruct(expected) && isscalarstruct(actual)
          struct_diffs = find_struct_differences(expected, actual);
          reason_msg = loc_prepare_message_from_diffs(struct_diffs, tolerance_msg);
       else
          reason_msg = loc_construct_diff_message(expected, actual, '', tolerance_msg);
       end
    else
       reason_msg = ['Expected and actual are equal' tolerance_msg '.'];
    end

    % varargin has been evaluated before
    mlunit_fail_with_reason(reason_msg, custom_msg);
end


function msg = loc_prepare_message_from_diffs(struct_diffs, tolerance_msg)

    error(nargchk(2, 2, nargin, 'struct'));
    
    first_n_items = 3;

    msgs = cell(size(struct_diffs));
    for sd = 1:numel(struct_diffs)
        
        % truncate output after first n differences
        if sd > first_n_items
            msgs{sd} = '... more differences detected, but not displayed.';
            break;
        
        % message for differing field values on both sides
        elseif isempty(struct_diffs(sd).missingin)
            msgs{sd} = loc_construct_diff_message(struct_diffs(sd).expected, struct_diffs(sd).actual, struct_diffs(sd).fieldpath, tolerance_msg);
        
        % message for field missing on one side
        else
            msgs{sd} = sprintf('Field %s missing in %s.', ...
                struct_diffs(sd).fieldpath, ...
                struct_diffs(sd).missingin);
        end
    end
    
    % prevent preallocated empty items from being joined into the message string
    msgs(sd+1:end) = [];
    
    msg = mlunit_strjoin(msgs, sprintf('\n'));

    
function msg = loc_construct_diff_message(expected, actual, position_info, tolerance_msg)

    error(nargchk(2, 4, nargin, 'struct'));
    
    if nargin < 3, position_info = ''; end
    if nargin < 4, tolerance_msg = ''; end
    
    position_msg = '';
    if ~isempty(position_info)
        position_msg = [' at position ' position_info];
    end
    
    expected_string = printable(expected);
    actual_string = printable(actual);
    
    change_msg = '';
    % append difference markers for string or cellstr comparisons
    if (ischar(expected) && ischar(actual)) || (iscellstr(expected) && iscellstr(actual))
        % apply a shortest Levenshtein alignment, if not empty
        alignment = shortest_alignment(expected_string, actual_string);
        if ~isempty(alignment)
            expected_string = alignment(1,:);
            actual_string = alignment(2,:);
        end
        
        change_msg = sprintf('\n  %-9s: %s', 'Changes', mark_string_differences(expected_string, actual_string));
    end

    msg = sprintf('Data not equal%s%s:\n  %-9s: %s\n  %-9s: %s%s', ...
        position_msg, ...
        tolerance_msg, ...
        'Expected', expected_string, ...
        'Actual', actual_string, ...
        change_msg);
