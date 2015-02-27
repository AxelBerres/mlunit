%Access private test_loader functions.

%  $Id: test_test_loader.m 46 2006-06-11 19:20:00Z thomi $

function self = set_up(self)

testloader_dir = fileparts(which('test_loader'));
private_dir = fullfile(testloader_dir, 'private');
cd(private_dir);

% for finding the test_test_loader methods after the path being bent over to the
% privates
test_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(test_dir);
