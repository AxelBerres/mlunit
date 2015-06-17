function writeXmlTestsuite(suiteresult, targetdir)
% WRITEXMLTESTSUITE Write the result of a test suite as jUnit compatible XML file.
%
% WRITEXMLTESTSUITE(suiteresult, targetdir)
%
% Input argument suiteresult is a structure of these fields:
%  name           the package name of the test suite
%  errors         the number of errors
%  failures       the number of failures
%  tests          the number of executed tests
%  time           the time used for executing the tests
%  testcaseList   a list of all testcases with specific information
%
%  Input argument targetdir defines the target directory for the XML
%  report.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$
  
   s_fileName = ['TEST-' suiteresult.name '.xml'];

   source = fullfile(targetdir, s_fileName);
   
   fid = fopen(source,'w');
   if fid == -1
       warning('MLUNIT:noFileAccess', 'Could not open file for writing: ''%s''.', source);
       return;
   end
   
   % default xml headline
   fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
   % wrap this string in a '%s' call in order to prohibit fprintf to parse
   % it
   fprintf(fid, '%s', printXmlTestsuite(suiteresult));
   fclose(fid);


%% Return XML string for test suite
% Input argument suiteresult is a structure of these fields:
%  name           the package name of the test suite
%  errors         the number of errors
%  failures       the number of failures
%  tests          the number of executed tests
%  time           the time used for executing the tests
%  testcaseList   a list of all testcases with specific information
function xml = printXmlTestsuite(suiteresult)

   timestamp = datestr(now,'yyyy-mm-ddTHH:MM:SS');
   attributes = {'name', suiteresult.name, ...
                 'errors', num2str(suiteresult.errors), ...
                 'failures', num2str(suiteresult.failures), ...
                 'tests', num2str(suiteresult.tests), ...
                 'time', num2str(suiteresult.time), ...
                 'hostname', 'unknown', ...
                 'timestamp', timestamp, ...
                };

   content = '';
   content = [content xmlTag('properties')];
   for tc = 1:length(suiteresult.testcaseList)
      content = [content printXmlTestcase(suiteresult.testcaseList{tc})]; %#ok<AGROW>
   end
   content = [content xmlTag('system-out')];
   content = [content xmlTag('system-err')];
   
   xml = xmlTag('testsuite', attributes, content);


%% Return XML string for test case
% List of testcase fields:
%     .name       the test case name
%     .classname  the name of the class/package, constructed from the
%                 relative path name and the test suite file name
%     .error      a description of its error. [] if no error.
%     .failure    a description of its failure. [] if no failure.
%     (.time)     the time used. Not supported.
function xml = printXmlTestcase(testcase)

   newline = sprintf('\n');

   attributes = {'classname', testcase.classname, ...
                 'name', testcase.name};
                 % time not available:
                 %'time', num2str(testcase.time), ...

   content = '';
   if ~isempty(testcase.error)
      content = [content xmlTag('error', {}, testcase.error, true)];
   end
   if ~isempty(testcase.failure)
      content = [content xmlTag('failure', {}, testcase.failure, true)];
   end

   xml = xmlTag('testcase', attributes, content);
   
   
%% provide HTML-safe version of a message
function message = sanitizeHtml(message)
   
   message = ['<![CDATA[' message ']]>'];


%% Return XML formatted tag from
%   - tagname string
%   - attributes cell string array
%   - content string
function xml = xmlTag(tagname, attributes, content, verbatim)

   if nargin<2, attributes={}; end
   if nargin<3, content=''; end
   if nargin<4, verbatim=false; end

   error(nargchk(1, 4, nargin, 'struct'));
   if ~ischar(tagname), error('tagname need be char'); end
   if ~ischar(content), error('content need be char'); end
   if ~(isempty(attributes) || (iscellstr(attributes) && mod(length(attributes), 2)==0))
      error('attributes need be empty, or cellstr of even length');
   end
   if ~islogical(verbatim) || numel(verbatim)~=1, error('verbatim need be scalar logical'); end
   
   
   newline = sprintf('\n');

   % start opening tag
   xml = ['<' tagname];

   % add attributes
   for i=1:2:length(attributes)
      xml = [xml ' ' attributes{i} '="' attributes{i+1} '"']; %#ok<AGROW>
   end
   
   % fill up to tag closing
   if isempty(content)
      % just finish-close the opening tag in case of no content
      xml = [xml '/>' newline];
   % add verbatim content
   elseif verbatim
      % make sure to not include unnecessary whitespace and newline between
      % the tag enclosings, also make sure the content is displayed as is
      xml = [xml '>' sanitizeHtml(content) '</' tagname '>' newline];
   % add normal content
   else
      % close opening tag
      xml = [xml '>' newline];

      % add content
      xml = [xml indentLines(content)];

      % add closing tag
      xml = [xml '</' tagname '>' newline];
   end


%% Indent lines of a given multi-line string by an indentation string
function indentedtext = indentLines(text, indentation)

   if nargin<2, indentation='  '; end

   error(nargchk(1, 2, nargin, 'struct'));
   if ~ischar(text), error('text need be char'); end
   if ~ischar(indentation), error('indentation need be char'); end

   % prepend by indentation every tag bracket that starts a new line 
   indentedtext = regexprep(text, '^(\s*<)', [indentation '$1'], 'lineanchors');