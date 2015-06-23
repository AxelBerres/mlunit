%Align two strings according to their smallest Levenshtein distance.
%  A = SHORTEST_ALIGNMENT(S1,S2) calculates a Levenshtein distance matrix and
%  aligns the strings S1 and S2 according to the smallest distance in it.
%  S1 and S2 must be row vectors of char.
%  
%  Favors changes over deletions/insertions where ambiguous.
%  Does not support transpositions.
%
%  TODO: calculate matrix backwards instead of forwards; saves eventual string reversal
%  TODO: drop distance, which is not really needed

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function alignment = shortest_alignment(s1, s2)

    error(nargchk(nargin,2,2,'struct'));

    isrowvector = @(v) isempty(v) || size(v, 1)==1;
    if ~isrowvector(s1) || ~ischar(s1), error('s1 need be row vector or empty, and of class char'); end
    if ~isrowvector(s2) || ~ischar(s2), error('s2 need be row vector or empty, and of class char'); end
    
    length1 = length(s1);
    length2 = length(s2);
    
    % prepare working matrices
    distance = repmat(NaN, length1+1, length2+1);
    path = cell(length1+1, length2+1);
    
    % fill base row/column
    distance(1, 1) = 0;
    path{1, 1} = [0, 0];
    for i1 = 2:length1+1
        distance(i1, 1) = i1-1;
        path{i1, 1} = [i1-1, 1];
    end
    for i2 = 2:length2+1
        distance(1, i2) = i2-1;
        path{1, i2} = [1, i2-1];
    end
    
    % calculate distances and build path matrix
    for i1 = 1:length1
        for i2 = 1:length2
            if isequal(s1(i1), s2(i2))
                distance(i1+1, i2+1) = distance(i1,i2);
                path{i1+1,i2+1} = [i1,i2];
                continue;
            end
            
            sources = {...
                [i1, i2], ...       % change/substitution
                [i1, i2+1], ...     % deletion
                [i1+1, i2], ...     % insertion
                };

            source_distances = cellfun(@(v) distance(v(1), v(2)), sources);
            minimum = min(source_distances);
            index_minsource = find(minimum == source_distances, 1);
            
            distance(i1+1, i2+1) = minimum + 1;
            path{i1+1, i2+1} = sources{index_minsource};
        end
    end
    
    % work out optimal path
    step = [length1+1, length2+1];
    pos = 1;
    a1 = '';
    a2 = '';
    blank = '·';
    while ~isequal([0, 0], (path{step(1), step(2)}))
        nextstep = path{step(1), step(2)};
        
        % deletion
        if step(1) == nextstep(1)
            a1(pos) = blank;
            a2(pos) = s2(step(2)-1);
            
        % insertion
        elseif step(2) == nextstep(2)
            a1(pos) = s1(step(1)-1);
            a2(pos) = blank;

        % change/substitution
        else
            a1(pos) = s1(step(1)-1);
            a2(pos) = s2(step(2)-1);
        end
        
        % update states
        pos = pos + 1;
        step = nextstep;
    end
    
    % construct string alignment
    alignment = [a1(end:-1:1);a2(end:-1:1)];
