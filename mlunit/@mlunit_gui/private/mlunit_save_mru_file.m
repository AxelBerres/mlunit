function mlunit_save_mru_file(input_name, input_dock, input_shorten)
%mlunit_save_mru_file save some or all parameters of the GUI.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

[test_case_name, dock, shorten] = mlunit_load_mru_file();

% Allow setting an empty name, as that is an option to run all tests in pwd recursively.
% But ignore empty doubles ([]), to provide a way to just set dock.
if nargin >= 1 && (~isempty(input_name) || ischar(input_name)), test_case_name = input_name; end
if nargin >= 2 && ~isempty(input_dock), dock = input_dock; end
if nargin >= 3 && ~isempty(input_shorten), shorten = input_shorten; end

save(mlunit_get_mru_file(), 'dock', 'test_case_name', 'shorten');
