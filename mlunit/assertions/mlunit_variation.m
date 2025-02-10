function data = mlunit_variation(func, varargin)
%MLUNIT_VARIATION Run a test multiple times, with different arguments.
%
%  MLUNIT_VARIATION(FUNC, ARGS) calls the function handle FUNC several times,
%  each time providing a different element of the cell array ARGS as input
%  argument to FUNC. Also known as parameter test.
%
%  If any of the calls trigger an assertion failure, the other calls continue to
%  run. Finally, all failures and errors are presented, and aggregated into the
%  test's result.
%
%  MLUNIT_VARIATION(FUNC, A1, A2, ...) does the same, providing 2, 3, or
%  more input arguments to FUNC. A1, A2,... each must be a cell array of the
%  same size, or of size 1.
%
%  Examples
%     >> mlunit_variation(@assert_contains, {'foobar', 'world'}, 'oob');
%
%  See also  MLUNIT_SKIP_VARIATION

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

%#ok<*SPRINTFN>

persistent variation_data;

% reset control and data exchange with test runner
if nargin == 1 && ischar(func) && strcmpi('reset', func)
    data = variation_data;
    variation_data = [];
    return
end

if isempty(variation_data)
    variation_data = loc_varstruct();
end

% must have some arguments at least
mlunit_narginchk(2, Inf, nargin);

% all elements of varargin must have the same size
all_assert_arguments = loc_expand_arguments(varargin);

assert_messages = {};
num_variations = numel(all_assert_arguments);
num_failures = 0;
num_skips = 0;
num_errors = 0;
for k = 1:num_variations
    assert_arguments = all_assert_arguments{k};
    try
        func(assert_arguments{:});
    catch me
        skip_whole_test = false;
        switch me.identifier
            case 'MLUNIT:Failure'
                num_failures = num_failures + 1;
                result = ' FAIL';
            case 'MLUNIT:SkippedVariation'
                num_skips = num_skips + 1;
                result = ' SKIPPED';
            case 'MLUNIT:Skipped'
                skip_whole_test = true;
                result = ' SKIPPED the whole test';
            otherwise
                num_errors = num_errors + 1;
                result = ' ERROR';
        end
        variation_id = mlunit_strjoin(cellfun(@printable, assert_arguments, 'UniformOutput', false));
        assert_messages{end+1} = sprintf('- Variation {%s}%s\n%s', variation_id, result, loc_indent(me.message)); %#ok<AGROW>
        if skip_whole_test
            mlunit_skip('%s', assert_messages{end});
        end
    end
end

if num_variations > 0
    variation_data(end+1) = loc_varstruct( ...
        num_variations, ...
        num_failures, ...
        num_skips, ...
        num_errors ...
        );
end

reason_message = mlunit_strjoin(assert_messages, sprintf('\n'));

if ~isempty(assert_messages)
    if num_errors > 0
        error('MLUNIT:variationError', reason_message);
    elseif num_failures > 0
        mlunit_fail(reason_message);
    elseif num_skips > 0
        if num_skips == num_variations && mlunit_param('all_variations_skip')
            mlunit_skip(reason_message);
        end
    else
        error('MLUNIT:variationError', 'Unexpected variation result:\n%s', reason_message);
    end
end


% Transform all input arguments into a single MxN cell array, where M is the
% number of variations, and N is the number of input arguments per variation.
function variations = loc_expand_arguments(arrays)

    % Check size constraints
    num_variations = 0;
    num_arguments = 0;
    for idx_array = 1:numel(arrays)
        % forego empty arguments
        if isempty(arrays{idx_array})
            continue
        end
        % count scalar argument as potential expansion
        if isscalar(arrays{idx_array}) || ...
                (isvector(arrays{idx_array}) && ischar(arrays{idx_array}))
            num_arguments = num_arguments + 1;
            num_variations = max(num_variations, 1);
            continue
        end
        % vectors of at least 2 items all need to be of length num_variations
        % arrays of at least 2x2 items all need to have num_variations columns
        if isvector(arrays{idx_array})
            inc_argument = 1;
            cur_num_variations = numel(arrays{idx_array});
        else
            inc_argument = size(arrays{idx_array}, 2);
            cur_num_variations = size(arrays{idx_array}, 1);
        end
        % count vector or array arguments
        num_arguments = num_arguments + inc_argument;
        if num_variations <= 1
            num_variations = cur_num_variations;
        elseif num_variations ~= cur_num_variations
            error('MLUNIT:variationError', 'Incompatible variation arguments. Argument number %d provides %d variations, but earlier arguments established %d variations.', idx_array, cur_num_variations, num_variations);
        end
    end

    variations = cell(num_variations, 1);
    for idx_variation = 1:numel(variations)
        variation = cell(1, num_arguments);
        idx_argument = 1;
        for idx_array = 1:numel(arrays)
            if isempty(arrays{idx_array})
                continue
            elseif isscalar(arrays{idx_array}) || ...
                    (isvector(arrays{idx_array}) && ischar(arrays{idx_array}))
                variation{idx_argument} = arrays{idx_array};
                idx_argument = idx_argument + 1;
            elseif isvector(arrays{idx_array})
                if iscell(arrays{idx_array})
                    variation{idx_argument} = arrays{idx_array}{idx_variation};
                else
                    variation{idx_argument} = arrays{idx_array}(idx_variation);
                end
                idx_argument = idx_argument + 1;
            else
                num_elements = size(arrays{idx_array}, 2);
                if iscell(arrays{idx_array})
                    [variation{idx_argument:idx_argument+num_elements-1}] = arrays{idx_array}{idx_variation, :};
                else
                    variation(idx_argument:idx_argument+num_elements-1) = num2cell(arrays{idx_array}(idx_variation, :));
                end
                idx_argument = idx_argument + num_elements;
            end
        end
        variations{idx_variation} = variation;
    end


function data = loc_varstruct(variations, failures, skips, errors)

    if nargin == 0
        data = struct(...
            'variations', {}, ...
            'failures', {}, ...
            'skips', {}, ...
            'errors', {} ...
            );
    else
        data = struct(...
            'variations', {variations}, ...
            'failures', {failures}, ...
            'skips', {skips}, ...
            'errors', {errors} ...
            );
    end


% Indent text by 4 spaces at beginning and after each newline
function indented = loc_indent(text)

    space = '    ';
    indented = [space regexprep(text, '\n', ['\n' space])];
