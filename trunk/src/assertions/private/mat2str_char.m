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

% handle empty strings differently
if isempty(input)
    outstring = ['''' input ''''];
    return
end

% wrap each line in apostrophes
cellinput = cellstr(input);
quoted_cellinput = cellfun(@(s) ['''' s ''''], cellinput, 'UniformOutput', false);

% separate multiple lines by semicolon and wrap brackets around
outstring = strjoin(quoted_cellinput, ';');
if numel(quoted_cellinput)>1
    outstring = ['[', outstring, ']'];
end
