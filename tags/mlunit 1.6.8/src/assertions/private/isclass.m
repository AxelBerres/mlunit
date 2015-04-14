%ISCLASS True for MATLAB objects
%  This is an isobject concurrent. Apparently, isobject returns false on some
%  objects, for example on Simulink.ModelWorkspace objects. isclass wants
%  to return true for these, too. Not for Java object, however, for which we
%  have isjava.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$
function result = isclass(s)

% there is no meaningful way to test for a variable being a class instance
% therefore, exclude every other option
% Will report as class object any types future MATLAB releases may introduce.
result = ...
    ~isnumeric(s) && ...
    ~islogical(s) && ...
    ~ischar(s) && ...
    ~iscell(s) && ...
    ~isstruct(s) && ...
    ~isa(s, 'function_handle') && ...
    ~isjava(s);
