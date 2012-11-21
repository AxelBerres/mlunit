% Use this script to set all paths of the mlUnit installation.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

basepath = fileparts(mfilename('fullpath'));

% add mlunit automation tools
addpath(genpath(basepath), '-end');
