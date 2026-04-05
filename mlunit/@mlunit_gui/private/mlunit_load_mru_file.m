function [test_case_name, docked, shorten] = mlunit_load_mru_file()
%mlunit_load_mru_file returns the mlunit GUI config file content.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

% default values
test_case_name = '';
docked = 0;
shorten = 0;

config_file = mlunit_get_mru_file();

if ~exist(config_file, 'file')
    return
end

try
    saved = load(config_file, '-mat');
    test_case_name = saved.test_case_name;
    docked = saved.dock;
    shorten = saved.shorten;
catch
    % delete inconsistent file
    delete(config_file);
end
