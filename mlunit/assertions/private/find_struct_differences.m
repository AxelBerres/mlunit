% Determine differences between two given structs. Recursively.
% Can only process struct arrays of size 1x1.
% Results are given as struct array, whose elements each provide information on
% one distinct difference. Each element has these fields:
%
%     fieldpath: the path of fieldnames of this difference, e.g. '.foo.bar'
%     missingin: 'expected' or 'actual', or '' if prevalent in both
%     expected: value of the field, [] if missingin=='expected'
%     actual: value of the field, [] if missingin=='actual'
%
% find_struct_differences currently has quadratic runtime, due to excessive use
% of isequal to detect differences on upper levels.

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

function struct_diffs = find_struct_differences(sa, sb, fieldpath)

    error(nargchk(2, 3, nargin, 'struct'));
    if ~isstruct(sa), error('sa need be struct'); end
    if ~isstruct(sb), error('sb need be struct'); end
    if numel(sa)~=1, error('sa need be scalar, i.e. of size [1 1]'); end
    if numel(sb)~=1, error('sb need be scalar, i.e. of size [1 1]'); end
    
    if nargin < 3
        fieldpath = '';
    end

    % start from empty and growable, therefore properly typed, struct
    struct_diffs = repmat(diff_type(), [0 0]);
    
    sa_fields = fieldnames(sa);
    sb_fields = fieldnames(sb);

    % fields missing in sb/actual
    excess_sa = setdiff(sa_fields, sb_fields);
    for i=1:numel(excess_sa)
        struct_diffs(end+1) = diff_type([fieldpath '.' excess_sa{i}], 'actual', sa.(excess_sa{i}), []); %#ok<AGROW>
    end
    
    % fields missing in sa/expected
    excess_sb = setdiff(sb_fields, sa_fields);
    for i=1:numel(excess_sb)
        struct_diffs(end+1) = diff_type([fieldpath '.' excess_sb{i}], 'expected', [], sb.(excess_sb{i})); %#ok<AGROW>
    end

    % fields that differ
    common_fields = intersect(sa_fields, sb_fields);
    for i=1:numel(common_fields)
        
        sa_value = sa.(common_fields{i});
        sb_value = sb.(common_fields{i});
        appended_fieldpath = [fieldpath '.' common_fields{i}];
        
        % only handle fields having differences
        if isequal(sa_value, sb_value)
            continue;
        end
        
        % only recurse for non-empty, scalar structs in sa as well as sb
        if isstruct(sa_value) && isscalar(sa_value) && isstruct(sb_value) && isscalar(sb_value)
            nested_diffs = find_struct_differences(sa_value, sb_value, appended_fieldpath);
            struct_diffs = horzcat(struct_diffs, nested_diffs);
        else
            struct_diffs(end+1) = diff_type(appended_fieldpath, '', sa_value, sb_value); %#ok<AGROW>
        end
    end

% Defines a struct with always these fields:
%   fieldpath: string, '' if empty
%   missingin: 'expected' or 'actual', or '' if in both
%   expected: any value, [] if missingin=='expected'
%   actual: any value, [] if missingin=='actual'
function type = diff_type(fieldpath, missingin, expected, actual)

    % no arguments, then construct empty 0x0 struct with types
    if nargin==0
        type = struct( ...
            'fieldpath', {}, ...
            'missingin', {}, ...
            'expected', {}, ...
            'actual', {});
        return;
    end

    error(nargchk(1, 4, nargin, 'struct'));
    if ~ischar(fieldpath), error('fieldpath need be char'); end
    if nargin<2, missingin = ''; end
    if nargin<3, expected = []; end
    if nargin<4, actual = []; end

    type = struct( ...
        'fieldpath', {fieldpath}, ...
        'missingin', {missingin}, ...
        'expected', {expected}, ...
        'actual', {actual});
