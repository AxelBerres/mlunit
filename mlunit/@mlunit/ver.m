function version = ver(self, only_verstring) %#ok
%mlunit/ver prints the version string of mlUnit to the standard output.
%
%  EXAMPLE
%  =======
%         ver(mlunit);
%
%  See also MLUNIT.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: ver.m 226 2007-01-21 15:20:53Z thomi $

version_struct = loc_find_mlunit_version();
version = version_struct.Version;

if nargin < 2 || ~only_verstring
    fprintf(1, 'mlUnit Version %s\n', version);
end


function mlunit_version_struct = loc_find_mlunit_version

    versions = ver();
    mlunit_findings = find(strcmpi('mlUnit', {versions.Name}));
    switch numel(mlunit_findings)
        case 0
            mlunit_version_struct = loc_unknown_version();
        case 1
            mlunit_version_struct = versions(mlunit_findings);
        otherwise
            mlunit_version_struct = versions(mlunit_findings(1));
            warning('MLUNIT:multipleVersions', 'Found multiple mlUnit versions on the MATLAB path. Using first to determine version number.');
    end


function mlunit_version_struct = loc_unknown_version()

    s = struct();
    s.Name = 'mlUnit';
    s.Version = '(unknown)';
    s.Release = '(R2007b)';
    s.Date = '';
