%MLUNIT_TEMPDIR Create temporary directory, copy content, remove automatically.
%  TDIR = MLUNIT_TEMPDIR creates a temporary directory, returning its path in TDIR.
%  When being called in a test function, or its set_up function, the directory is
%  available during the test and its tear_down function. After having run tear_down,
%  mlUnit will delete the temporary directory.
%  When being called in a suite_set_up function, the directory is available during all the
%  suite's tests and the suite's suite_tear_down function. After havin run
%  suite_tear_down, mlUnit will delete the temporary directory.
%
%  TDIR = MLUNIT_TEMPDIR(FILEPATH) does the same, but also copies FILEPATH, which may be a
%  relative or absolute path to an existing file or directory. If FILEPATH is a file,
%  it is copied directly into the temporary directory. If FILEPATH is a directory, its
%  contents are copied into the temporary directory.
%
%  TDIR = MLUNIT_TEMPDIR(ZIPPATH) copies the ZIP file's contents into the temporary
%  directory.
%
%  TDIR = MLUNIT_TEMPDIR(P1, P2, P3, ...) does all of the above and P1, P2, P3, ... may
%  each be a FILEPATH or ZIPPATH. All those contents are copied into the temporary
%  directory.
%
%  Examples
%
%     % create just the directory
%     tdir = mlunit_tempdir;
%
%     % create the directory and copy the matlabrc.m there
%     tdir = mlunit_tempdir(which('matlabrc.m'));

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function dirPath = mlunit_tempdir(varargin)

   % create temporary directory
   dirPath = tempname;
   
   % catch warnings and errors by fetching mkdir's output arguments
   [status, message, msgid] = mkdir(dirPath);
   if status == 0
      error('MLUNIT:TempdirImpossible', [ ...
         'MATLAB could not create an mlUnit temporary directory:\n' ...
         '  Directory: %s\n' ...
         '  MessageId: %s\n' ...
         '  Message  : %s' ...
         ], dirPath, msgid, message);
   elseif strcmp('MATLAB:MKDIR:DirectoryExists', msgid)
      error('MLUNIT:TempdirCollision', [ ...
         'mlUnit temporary directory already exists. Cannot guarantee empty directory. Trying again might work next time.\n' ...
         '  Path   : %s\n' ...
         '  Message: %s' ...
         ], dirPath, message);
   end

   % register new tempdir for deletion
   tempdirs = mlunit_param('mlunit_tempdirs');
   if isempty(tempdirs)
      tempdirs = {};
   end
   % tempdirs will always be absolute paths, as created by tempname
   tempdirs{end+1} = dirPath;
   mlunit_param('mlunit_tempdirs', tempdirs);
   
   % copy and unzip
   if nargin >= 1
      for i = 1:numel(varargin)
         if ~ischar(varargin{i}) || isempty(varargin{i})
            continue
         end
         
         existcode = exist(varargin{i}, 'file');
         [dummy1, dummy2, extension] = fileparts(varargin{i}); %#ok<ASGLU>
         
         % unzip if ZIP file
         if 2 == existcode && strcmpi('.zip', extension)
            unzip(varargin{i}, dirPath);
            
         % copy if file or directory
         elseif any([2, 3, 4, 6, 7] == existcode)
            copyfile(varargin{i}, dirPath);
         end
      end
   end
