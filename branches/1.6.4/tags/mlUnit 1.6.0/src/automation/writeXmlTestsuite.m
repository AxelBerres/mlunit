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

%  $Author$
%  $Id$
  
   s_fileName = ['TEST-' suiteresult.name '.xml'];

   source = fullfile(targetdir, s_fileName);
   
   fid = fopen(source,'w');
   % default xml headline
   fprintf(fid,'<?xml version=''1.0'' encoding=''UTF-8''?>\n');
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
   newline = sprintf('\n');
   
   suitetag = ['<testsuite name="', suiteresult.name, '" ', ...
                        'errors="', num2str(suiteresult.errors), '" ', ...
                      'failures="', num2str(suiteresult.failures), '" ', ...
                         'tests="', num2str(suiteresult.tests), '" ', ...
                          'time="', num2str(suiteresult.time), '" ', ...
                      'hostname="unknown" ', ...
                     'timestamp="', timestamp,'">', ...
                       newline];
                       % 'hostname="unkown" ',...
   proptag = ['  <properties/>' newline];
   sysouttag = ['  <system-out/>' newline];
   syserrtag = ['  <system-err/>' newline];
   suiteclosetag = ['</testsuite>' newline];
   
   testcaseblock = '';
   for tc = 1:length(suiteresult.testcaseList)
      testcaseblock = [testcaseblock printXmlTestcase(suiteresult.testcaseList{tc})];
   end
   
   xml = [suitetag proptag testcaseblock sysouttag syserrtag suiteclosetag];


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
   
   fail = false;
   error = '';
   failure = '';
   if ~isempty(testcase.error)
      fail = true;
      error = ['    <error>', ...
                 sanitizeHtml(testcase.error), ...
                 newline, ...
                 '    </error>', ...
                 newline];
   end
   if ~isempty(testcase.failure)
      fail = true;
      failure = ['    <failure>', ...
                  sanitizeHtml(testcase.failure), ...
                  newline, ...
                  '    </failure>', ...
                  newline];
   end
   
   casetag = ['  <testcase classname="', testcase.classname, '" ', ...
                               'name="', testcase.name, '"'];
                  % time not available: num2str(testcase.time)
   
   if fail
      casetag = [casetag '>' newline];
      caseclose = ['  </testcase>' newline];
   else
      casetag = [casetag '/>' newline];
      caseclose = '';
   end

   xml = [casetag error failure caseclose];

   
%% sanitize HTML message
function message = sanitizeHtml(message)
   
   message = strrep(message,'<','(');
   message = strrep(message,'>',')');
