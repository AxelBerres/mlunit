% Determine if a given name corresponds to a @class or function.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function isclass = is_class_test(testname)

    testpath = which(testname);
    [dummy, dirname] = fileparts(fileparts(testpath));
    isclass = ~isempty(dirname) && strcmp(['@' testname], dirname);
