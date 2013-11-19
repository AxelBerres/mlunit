% Generates an empty file with a default header.
%
% Description:
% Generates an empty file with a default header. The file name string is
% specified without the ending .m and the file will be generated in the
% current directory.
%
% Syntax: 
%    >> createScript(s_fileName)
%
% INPUT PARAMETERS:
%    s_fileName - file name string without file extension
%
% OUTPUT PARAMETERS:

%
% EXAMPLES:
%	>> createScript('newFile')
%   creates the file newFile.m with the default header.
%
% See also:
%

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

% Author: Axel Berres
% $Id$
% ------------------------------------------------------------
% history
% 2010/14/09 - created

function createScript(s_fileName)

    % define a default file in case of a missing filename
    if nargin < 1, s_fileName = 'file'; end;

    % check if the desired file already exists 
    if exist(s_fileName,'file'),
        warning('file already exist');
        return;
    end

    % create file an write the header
    fid = fopen([s_fileName,'.m'],'w+');
    loc_writeHeader(fid);

    % close file
    fclose(fid);

%% fill header info    
function loc_writeHeader(fid)

    s_date = datestr(now, 'yyyy/dd/mm');
    
    fprintf(fid, '%% TODO: short description\n');
    fprintf(fid, '%%\n');
    fprintf(fid, '%% Description:\n');
    fprintf(fid, '%%    TODO: description\n');
    fprintf(fid, '%%\n');
    fprintf(fid, '%% Syntax: \n');
    fprintf(fid, '%%    >> TODO: add function syntax\n');
    fprintf(fid, '%%\n');
    fprintf(fid, '%% INPUT PARAMETERS:\n');
    fprintf(fid, '%%    TODO: add input parameter and options\n');
    fprintf(fid, '%%\n');
    fprintf(fid, '%% OUTPUT PARAMETERS:\n');
    fprintf(fid, '%%    TODO: add output parameter\n');
    fprintf(fid, '%%\n');
    fprintf(fid, '%% EXAMPLES:\n');
    fprintf(fid, '%%	>> TODO: add examples with description\n');
    fprintf(fid, '%%\n');
    fprintf(fid, '%% See also:\n');
    fprintf(fid, '%%    TODO: add cross reference\n');
    fprintf(fid, '\n');
    fprintf(fid, '%% *************************************************************************\n');
    fprintf(fid, '%% Copyright:    Model Engineering Solutions GmbH, 2009 - 2010 \n');
    fprintf(fid, '%% Date:         $Date:$\n');
    fprintf(fid, '%% Revision:     $Rev:$\n');
    fprintf(fid, '%% Author:       Axel Berres (axel.berres@model-engineers.com)\n');
    fprintf(fid, '%% *************************************************************************\n');
    fprintf(fid, '%% history\n');
    fprintf(fid, '%% %s - created\n', s_date);
    