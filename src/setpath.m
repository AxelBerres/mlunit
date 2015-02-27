% Set all paths of the mlUnit installation.
%  This does not include the test directories holding mlUnit's own tests.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function setpath

basepath = fileparts(mfilename('fullpath'));

% add mlunit automation tools
addpath(genpath(basepath), '-end');
