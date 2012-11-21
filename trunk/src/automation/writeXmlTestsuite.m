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
%  $Author$
%  $Id$
  
   s_fileName = ['TEST-' suiteresult.name '.xml'];

   source = fullfile(targetdir, s_fileName);
   
   fid = fopen(source,'w');
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
      content = [content xmlTag('error', {}, [sanitizeHtml(testcase.error) newline])];
   end
   if ~isempty(testcase.failure)
      content = [content xmlTag('failure', {}, [sanitizeHtml(testcase.failure) newline])];
   end

   xml = xmlTag('testcase', attributes, content);
   
   
%% strip text off HTML characters
function message = sanitizeHtml(message)
   
   message = strrep(message,'<','(');
   message = strrep(message,'>',')');


%% Return XML formatted tag from
%   - tagname string
%   - attributes cell string array
%   - content string
function xml = xmlTag(tagname, attributes, content)

   if nargin<2, attributes={}; end
   if nargin<3, content=''; end

   assert(nargin >= 1);
   assert(ischar(tagname));
   assert(isempty(attributes) || ...
         (iscellstr(attributes) && mod(length(attributes), 2)==0));
   assert(ischar(content));

   
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

   assert(nargin >= 1);
   assert(ischar(text));
   assert(ischar(indentation));

   % prepend every stream of non-newline characters by indentation
   % only prepend lines that start with a tag bracket
   % this may break tags whose attributes span multiple lines
   indentedtext = regexprep(text, '(\w*<[^\n]*)', [indentation '$1']);

