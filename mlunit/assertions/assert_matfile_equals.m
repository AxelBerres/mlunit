function assert_matfile_equals(expected, actual, varargin)
%ASSERT_MATFILE_EQUALS Raise an error if two mat Files differ.
%  ASSERT_MATFILE_EQUALS(EXPECTED, ACTUAL) raises a MATLAB error if EXPECTED
%  and ACTUAL are not pointing to files which are equal. Mat Files are equal if 
%  both hold the same variables and those variables are equal.
%
%  ASSERT_MATFILE_EQUALS(EXPECTED, ACTUAL, MSG, varargin) does the same, but
%  with added custom failure message MSG, which may reference sprintf arguments
%  in varargin.
%
%  Examples
%     % asserts that giving files they are equal
%     assert_matfile_equals('reference.mat', 'actual.mat');
%
%  See also  assert_exist_file

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

mlunit_narginchk(2,Inf,nargin);

checkFile( expected, varargin{:});
checkFile( actual, varargin{:});
checkMember( expected, actual, varargin{:} );
names2Check = checkMember( actual, expected);

for i=1:numel(names2Check)
    checkVariable( names2Check{i}, expected , actual, varargin{:});
end
   
function checkFile( file, varargin)
   if ~ischar( file)
      reason = sprintf('%s input needs to be a string pointing to a file!',inputname(1));
      mlunit_fail_with_reason(reason, varargin{:});
   end
   if ~(exist( file, 'file') == 2)
      reason = sprintf('Argument given for variable ''%s'' does not point to a file (%s)', inputname(1), file);
      mlunit_fail_with_reason(reason, varargin{:});
   end
%end of function   

function expectedVariables = checkMember( reference, toCheck, varargin )
   expectedVariables = who('-File', reference);
   toCheckVariables = who('-File', toCheck);  
   
   isMemberOfToCheck = ismember( expectedVariables, toCheckVariables);
   if ~isempty( isMemberOfToCheck) && ~(all( isMemberOfToCheck))
        missingVariables = expectedVariables( ~isMemberOfToCheck);
        reason = sprintf('Files differ because Variable(s): %s are not present in %s File',sprintf(' %s,', missingVariables{:}), inputname(1));
        mlunit_fail_with_reason(reason, varargin{:});
   end
%end of function

function checkVariable( variableName, expectedFile, actualFile, varargin)
   actualVariable = load( actualFile, variableName);
   expectedVariable = load( expectedFile, variableName);
   if ~isequal( actualVariable, expectedVariable)
      reason = sprintf('Variable ''%s'' expected to be %s, but actually was %s.', variableName, printable(expectedVariable), printable(actualVariable));
      mlunit_fail_with_reason(reason, varargin{:});
   end   
%end of function
