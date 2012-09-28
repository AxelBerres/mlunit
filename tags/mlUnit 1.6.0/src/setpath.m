% Use this script to set all paths of the mlUnit installation.

basepath = fileparts(mfilename('fullpath'));

% add mlunit automation tools
addpath(genpath(basepath), '-end');
