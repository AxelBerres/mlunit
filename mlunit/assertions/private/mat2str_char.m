function outstring = mat2str_char(input)
%MAT2STR_CHAR Emulate MAT2STR output for char input, even on old releases.
%
%  On R2006b, mat2str prints strings awkwardly. Enforce new style:
%  ['foo';'bar'] for character arrays, 'foobar' for single strings
%  Only works on char arrays with ndims<=2, as mat2str does, BTW.
%  However, no explicit error for ndims > 2 is raised, for speed.
%
%  See also MAT2STR

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

% save execution time by omitting preventable function calls
if nargin ~= 1, error(nargchk(1,1,nargin,'struct')); end
if ~ischar(input), error('input need be char'); end

% handle empty strings safely
if isempty(input)
    outstring = '''''';
    return
end

% wrap each line in apostrophes
quoted_cellinput = loc_cellstr_from_char(input);
for i=1:numel(quoted_cellinput)
    quoted_cellinput{i} = ['''' quoted_cellinput{i} ''''];
end

% separate multiple lines by semicolon and wrap brackets around
outstring = '';
% explicitly instead of mlunit_strjoin for speed
for i=1:numel(quoted_cellinput)-1
    outstring = [outstring quoted_cellinput{i} ';']; %#ok<AGROW>
end
if numel(quoted_cellinput)>=1
    outstring = [outstring, quoted_cellinput{end}];
    if numel(quoted_cellinput)>1
        outstring = ['[', outstring, ']'];
    end
end


% Roll our own cellstr function without a deblanking "feature".
% MATLAB's cellstr eats trailing whitespace from each row without warning.
% MATLAB should eat toast.
% For optimized execution time, we outright expect non-empty char input of at
% most 2 dimensions
function c = loc_cellstr_from_char(s)

    rows=size(s,1);%#ok ignore rows
    c = cell(rows,1);	
    for i=1:rows
        c{i} = s(i,:);
    end
