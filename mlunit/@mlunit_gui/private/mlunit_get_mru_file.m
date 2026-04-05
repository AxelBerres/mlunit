function config_file = mlunit_get_mru_file()
%mlunit_get_mru_file determines the location of the mlunit GUI config file.
%
%  Will create the directory for the file.
%  Usually %APPDATA%/mlunit/mlunit_gui_settings.mat on Windows,
%  or $HOME/.config/mlunit/mlunit_gui_settings.mat on other systems.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

if ispc
    appdata = getenv('APPDATA');

else
    appdata = getenv('XDG_STATE_HOME');
    if isempty(appdata)
        % fall back
        appdata = fullfile(getenv('HOME'), '.config');
    end
end

mlunit_appdata = fullfile(appdata, 'mlunit');
[mkdirok, mkdirmsg] = mkdir(mlunit_appdata);
if ~mkdirok
    return
end

config_file = fullfile(mlunit_appdata, 'mlunit_gui_settings.mat');
