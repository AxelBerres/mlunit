%Obtain the function handle to each given subfunction name.
%
%  Compatibility: R2011b and newer, especially R2015b and R2016b. Will not work
%  on releases older than R2011b, due to lack of getArrayFromByteStream.
%
%  See mlunit_get_subfunction_handle

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function handles = get_subfunction_handles(self, filename, subfunc_names) %#ok<INUSL>

    mlunit_narginchk(3,3,nargin);
    
    handles = cellfun(@(sname)get_subfunction_handle(filename, sname), subfunc_names, 'UniformOutput', false);
end
