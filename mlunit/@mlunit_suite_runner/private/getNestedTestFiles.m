function suitespecs = getNestedTestFiles(basedir, include_matlab_tests)
% GETNESTEDTESTFILES returns a list of all test_*.m files in all
% subdirectories. The subdirectories are queried by genpath(). Therefore,
% subdirectories beginning with @ will be excluded.
%
% GETNESTEDTESTFILES(BASEDIR, INCLUDEMATLABTESTS) returns a list of all
% test_*.m files in BASEDIR. If INCLUDEMATLABTESTS is true, then MATLAB unit tests
% are included as well.
%
% The return value is a cell array of structures. Each structure contains:
%     testname the name of the found test file
%     fulldir  the absolute path of the containing directory
%     reldir   the relative path of the containing directory, set back
%              against the basedir input argument

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

   % get list of directories
   dirlist = dirset(basedir);
   
   % build relative dir name for each directory name
   reldirlist = strrep_first(dirlist, basedir, '');     % crop basedir
   
   % search pattern
   search_prefix = 'test_';
   search_suffix = '.m';
   
   suitespecs = [];
   
   % get files from each directory
   for iDir = 1:numel(dirlist)
      
      % get test class item
      [classpath classname classext] = fileparts(dirlist{iDir});
      if isclassdir(classname)
          if isequal(1, strmatch(search_prefix, clean_classname(classname)))
              spec = struct();
              spec.testname = classname;
              spec.reldir = strrep_first(classpath, basedir, '');
              spec.fulldir = classpath;
              spec.object = [];
              spec.testselection = {};
              suitespecs{end+1} = spec;
          end
          continue;
      end
       
      % get list of test files
      files = dir(dirlist{iDir});
      ids = strmatch(search_prefix, {files.name});
      tests = {files(ids).name};
      
      for iFile = 1:numel(tests)
         [path name ext] = fileparts(tests{iFile});
         if strcmp(ext, search_suffix)
            
            spec = struct();
            spec.testname = name;
            spec.reldir = reldirlist{iDir};
            spec.fulldir = dirlist{iDir};
            spec.object = [];
            spec.testselection = {};

            suitespecs{end+1} = spec;
         end
      end
   end

   if include_matlab_tests
      
      % let MATLAB find its tests itself, but only class-based tests
      if verLessThan('matlab', '9.9.0')
         % does not find classes in packages at all
         parse_results = matlab.unittest.internal.runtestsParser(basedir, 'IncludeSubfolders', true, 'SuperClass', 'matlab.unittest.TestCase');
         matlab_tests = testsuite(parse_results.TestsuiteInputs{:});

      % from R2020b onwards, use the new parser call
      else
         % finds test classes in packages only from R2022a onwards
         [parse_results, matlab_tests] = matlab.unittest.internal.runtestsParser(@testsuite, basedir, 'IncludeSubfolders', true, 'SuperClass', 'matlab.unittest.TestCase');
      end

      % segment all found MATLAB tests into their respective suites
      all_suite_names = cellfun(@get_matlab_classname, {matlab_tests.Name}, 'UniformOutput', false);
      unique_suite_names = unique(all_suite_names);

      for i = 1:numel(unique_suite_names)

          matches = strcmp(all_suite_names, unique_suite_names{i});
          
          spec = struct();
          spec.matlabtests = matlab_tests(matches);
          spec.matlabparser_results = parse_results;
          spec.testname = unique_suite_names{i};
          spec.reldir = strrep_first(spec.matlabtests(1).BaseFolder, basedir, '');
          spec.fulldir = spec.matlabtests(1).BaseFolder;
          spec.object = [];
          spec.testselection = {};

          suitespecs{end+1} = spec;
      end
   end

   
function bIsClass = isclassdir(name)

    bIsClass = ~isempty(name) && strcmp(name(1), '@');

function name = clean_classname(name)

    if ~isempty(name)
        name = name(2:end);
    end

function name = get_matlab_classname(suite_name)

    parts = mlunit_strsplit(suite_name, '/');
    name = parts{1};
