function outstring = mat2str_char(input)
%MAT2STR_CHAR Emulate MAT2STR output for char input, even on old releases.
%
%  On R2006b, mat2str prints strings awkwardly. Enforce new style:
%  ['foo';'bar'] for character arrays, 'foobar' for single strings
%  Only works on char arrays with ndims<=2, as mat2str does, BTW.
%
%  See also MAT2STR

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

error(nargchk(1,1,nargin,'struct'));
if ~ischar(input), error('input need be char'); end

% handle empty strings safely
if isempty(input)
    outstring = '''''';
    return
end

% wrap each line in apostrophes
cellinput = loc_cellstr(input);
quoted_cellinput = cellfun(@(s) ['''' s ''''], cellinput, 'UniformOutput', false);

% separate multiple lines by semicolon and wrap brackets around
outstring = mlunit_strjoin(quoted_cellinput, ';');
if numel(quoted_cellinput)>1
    outstring = ['[', outstring, ']'];
end


% Roll our own cellstr function without a deblanking "feature".
% MATLAB's cellstr eats trailing whitespace from each row without warning.
% MATLAB should eat toast.
function c = loc_cellstr(s)

    if ischar(s)
        if isempty(s)
            c = {''};
        else
            if ndims(s)~=2
                error('MATLAB:cellstr:InputShape','S must be 2-D.')
            end
            [rows,cols]=size(s);%#ok ignore rows
            c = cell(rows,1);	
            for i=1:rows
                c{i} = s(i,:);
            end
        end
    elseif iscellstr(s)
        c = s; 
    else
        error('MATLAB:cellstr:InputClass','Input must be a string.')
    end
