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
%  �Author: Thomas Dohmke <thomas@dohmke.de> �
%  $Id: ver.m 226 2007-01-21 15:20:53Z thomi $

version = '1.7.0-SNAPSHOT';

if nargin < 2 || ~only_verstring
    fprintf(1, 'mlUnit Version %s\n', version);
end
