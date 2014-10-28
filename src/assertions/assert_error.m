function assert_error(func, errspec)
%ASSERT_ERROR Raise an error if a call does not throw an error.
%  ASSERT_ERROR(FUNC) calls the function handle FUNC and raises an error if the
%  function returns without error. Use it to assert that a certain function
%  definitely raises an error. If you need to bind variable values to the
%  function's input arguments, do so by an intermediate anonymous function.
%  Also see examples.
%
%  ASSERT_ERROR(FUNC, ERRID) does the same. Also raises an error when the
%  identifier of FUNC's error does not equal string ERRID.
%
%  ASSERT_ERROR(FUNC, ERRSTRUCT) does the same, but with a typical error
%  structure as argument. Set any of fields 'identifier', 'message', 'stack' in
%  ERRSTRUCT to let each be compared to the actual error's fields. Only set
%  fields will be compared. This enables you to compare the call stack. You
%  can limit the comparison to some parts of a call stack's fields. The fields
%  are: file, name, line. By providing only one or two of them in your expected
%  call stack structure, only those fields will be compared.
%  
%  ASSERT_ERROR(EXPRSTRING, ERRID/ERRSTRUCT) evaluates the string EXPRSTRING
%  and raises an error if the evaluation did not raise an error itself. Use this
%  to rather call arbitrary MATLAB expressions instead of single functions. Same
%  rules for ERRID/ERRSTRUCT arguments as above apply.
%
%  Examples
%     % asserts variable arg being empty
%     assert_error('error');
%
%     % the same, with message check
%     assert_error('error(''huh\nha'');', 'huh\nha');
%
%     % use an anonymous function for injecting variable values
%     v1 = 3; v2 = {};
%     assert_error(@() max(v1, v2), 'MATLAB:UndefinedFunction');
%
%  See also  FAIL, ASSERT_TRUE, ASSERT_WARNING

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

error(nargchk(1, 2, nargin, 'struct'));

% determine what to check for
if nargin < 2
   % checks for any error at all
   errcomp = struct();
elseif ischar(errspec)
   % checks for identifier
   errcomp = struct('identifier', {errspec});
elseif isstruct(errspec)
   % checks for anything the user specified
   errcomp = errspec;
else
   error('assert_error: ERRSPEC argument must be either an error id string or a error struct.');
end

% execute function/evalstring
bCaught = false;
try
   if isa(func, 'function_handle')
      func();
   else
      eval(func);
   end
catch
   bCaught = true;
   % use lasterror instead of catch for R2006b compatibility
   differences = error_struct_diff(errcomp, lasterror());
   % we have a match when there are no relevant differences
   bErrorMatch = isempty(fieldnames(differences));
end

% evaluate findings
if ~bCaught
   % no error at all is a failed expectation
   fail('Error expected, but none occurred.');
elseif ~bErrorMatch
   % don't use sprintf %s expansion here, in order to preserve special
   % characters in the strings
   fail(['Error occurred, but did not match criteria. ' diff2string(differences)]);
end


% Return a structure with only those fields that do not equal throughout error
% structures expected and actual. Only compares fields that both structures
% have. Each of the returned structure's field's values themselves is a structure
% with fields 'expected' and 'actual'.
function diff = error_struct_diff(expected, actual)

   diff = struct();
   
   % compare those error details
   fields = intersect(fieldnames(expected), fieldnames(actual));
   % compare each and every field for equality
   for f = 1:length(fields)
      % actual error message needs to be cleaned from assert_error specific stuff
      if strcmp(fields{f}, 'message')
         % Eat first line that should read 'Error using ==> assert_error', terminated
         % by a newline. The actual message comes after it. Filter the offending line
         % with a regular expression rather than a simple strrep, because after '==>',
         % MATLAB puts an HTML statement from R2007b on, and plain text before.
         actual.message = regexprep(actual.message, 'Error using .*\n', '', 'dotexceptnewline');
      end

      % filter actual stack fields to include only expected outputs
      if strcmp(fields{f}, 'stack')
         surplus_fields_actual = setdiff(fieldnames(actual.stack), fieldnames(expected.stack));
         surplus_fields_expected = setdiff(fieldnames(expected.stack), fieldnames(actual.stack));
         actual.stack = rmfield(actual.stack, surplus_fields_actual);
         expected.stack = rmfield(expected.stack, surplus_fields_expected);
      end
      
      if ~isequal(expected.(fields{f}), actual.(fields{f}))
         diff.(fields{f}) = struct('expected', {expected.(fields{f})}, 'actual', {actual.(fields{f})});
      end
   end


function string = diff2string(diff)

   diffstring = @(field) ['Expected error ' field ' ' printable(diff.(field).expected) ' actually was ' printable(diff.(field).actual) '.'];
   diffstrings = cellfun(diffstring, fieldnames(diff), 'UniformOutput', false);
   string = strjoin(diffstrings, sprintf('\n'));
