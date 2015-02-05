function assert_matfile_equals(expected, actual)
%ASSERT_MATFILE_EQUALS Raise an error if two mat Files differ.
%  ASSERT_MATFILE_EQUALS(EXPECTED, ACTUAL) raises a MATLAB error if EXPECTED
%  and ACTUAL are not pointing to files which are equal. Mat Files are equal if 
%  both hold the same variables and those variables are equal.
%
%  Examples
%     % asserts that giving files they are equal
%     assert_matfile_equals('reference.mat', 'actual.mat');
%
%  See also  assert_file_equals

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id: assert_matfile_equals.m 167 2012-06-06 16:10:56Z jens.dorroch $

if nargin < 2,
   error('assert_equals: Not enough input arguments.');
end

checkFile( expected);
checkFile( actual);
checkMember( expected, actual );
names2Check = checkMember( actual, expected);

for i=1:numel(names2Check)
    checkVariable( names2Check{i}, expected , actual);
end
   
function checkFile( file)   
   if ~ischar( file)
      fail( '%s input needs to be a string pointing to a file!',inputname(1));
   end
   if ~(exist( file, 'file') == 2)
      fail('Argument given for variable ''%s'' does not point to a file (%s)', inputname(1), file);
   end
%end of function   

function expectedVariables = checkMember( reference, toCheck )
   expectedVariables = who('-File', reference);
   toCheckVariables = who('-File', toCheck);  
   
   isMemberOfToCheck = ismember( expectedVariables, toCheckVariables);
   if ~isempty( isMemberOfToCheck) && ~(all( isMemberOfToCheck))
        missingVariables = expectedVariables( ~isMemberOfToCheck);
        fail('Files differ because Variable(s): %s are not present in %s File',sprintf(' %s,', missingVariables{:}), inputname(1));
   end
%end of function

function checkVariable( variableName, expectedFile, actualFile)
   actualVariable = load( actualFile, variableName);
   expectedVariable = load( expectedFile, variableName);
   if ~isequal( actualVariable, expectedVariable)
      fail('Variable ''%s'' expected to be %s, but actually was %s.', variableName, printable(expectedVariable), printable(actualVariable));
   end   
%end of function
