%DIRSET Find directories, recursively.
%   D = DIRSET(basedir) returns a cell array of path strings
%   that match all directories that lie beneath basedir, including basedir.
%   basedir must exist.
%
%   D = DIRSET() or D = DIRSET('') will do the same, but in the current working
%   directory.
%
%   D = DIRSET(basedir, depth_first) will do the same, using depth first search
%   if depth_first is true, or breadth first search, of depth_first is false.
%
%   See also dir.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function absdirs = dirset(basedir, depth_first)

    % use current working directory if no basedir given
    if nargin == 0, basedir = pwd; end
    % check non-empty dirs for existence; an empty basedir will be handled like
    % pwd, but yielding relative paths
    if ~isempty(basedir) && exist(basedir, 'dir') ~= 7
        error('PATHTOOLS:missingDir', '%s does not exist.', basedir);
    end

    % go depth_first by default
    if nargin < 2, depth_first = true; end
    
    % Use iteration rather than function recursion, because nesting depth
    % may well exceed MATLAB's recursion limit. For efficency, use an index into
    % the result array rather than a separate queue/stack of items unchecked.
    % Anyway, we cannot know how many directories we may find.
    absdirs = {basedir};
    current = 1;
    while current <= numel(absdirs)
        dirnames = dirset_plain(absdirs{current});
        % patch up into full absolute path
        fullcurrentpath = @(path) fullfile(absdirs{current}, path);
        subdirs = cellfun(fullcurrentpath, dirnames, 'UniformOutput', false);

        if depth_first
            % append for depth first search
            absdirs = [absdirs(1:current); ...
                       subdirs; ...
                       absdirs(current+1:end)];
        else
            % append for breadth first search
            absdirs = [absdirs; subdirs];  %#ok<AGROW>
        end
        current = current + 1;
    end
    
    
% Return row vector of non-recursive subdirs.
function dirnames = dirset_plain(basedir)

    % query basedir's subdirs
    if isempty(basedir)
        % dir() does not work with ''
        path_infos = dir();
    else
        path_infos = dir(basedir);
    end
    dir_infos = path_infos([path_infos.isdir]);
    
    % filter . and .. and leading dot directories,  and return names only
    filter_metadirs = @(dirs) dirs(~ismember(dirs, {'.', '..'}));
    filter_leadingdots = @(n) n(cellfun('isempty', regexp(n, '^\.', 'once')));
    % carefully return column vector here
    dirnames = filter_leadingdots(filter_metadirs({dir_infos.name}'));
