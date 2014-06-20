%ISMATLAB Verify interpreter to be MATLAB
%  ISMATLAB returns true if running in MATLAB, false if running in Octave. Not
%  tested with FreeMat.
%

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$
function isml = ismatlab()

    isml = ~isempty(ver('matlab'));
