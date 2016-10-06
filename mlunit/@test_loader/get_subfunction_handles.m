%Documentation

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function handles = get_subfunction_handles(self, filename, subfunc_names) %#ok<INUSL>

    mlunit_narginchk(3,3,nargin);
    
    handles = cellfun(@(sname)get_subfunction_handle(filename, sname), subfunc_names, 'UniformOutput', false);
end
