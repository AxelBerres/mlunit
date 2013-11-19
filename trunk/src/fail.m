function fail(msg, varargin)
%FAIL Raise an error.
%  FAIL(MSG, varargin) raises a MATLAB error. MSG is a string containing
%  the fail message. MSG may contain sprintf arguments, which can be
%  expanded by subsequent arguments in varargin. MSG will only be sprintf-
%  evaluated if subsequent arguments are actually provided.
%
%  The resulting error message will also contain a stack trace.
%
%  Examples
%     % raises a failure with a simple message
%     fail('Test failed.');
%
%     % raises a failure with a sprintf message, expanded by a variable
%     fail('Test failed, because 3 was not %d.', number);

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

% set empty message if left empty, take msg, or interpret sprintf arguments
switch nargin
case 0
   msg_string = '';
case 1
   msg_string = msg;
otherwise
   % avoid multiple sprintf calls on msg in case msg contains masked
   % sprintf control sequences that should not be interpreted
   msg_string = sprintf(['\nAssertionError message: ' msg], varargin{:});
end

% get calling stack with absolute file names
stack = dbstack('-completenames');
% But also extract the file names only. The resulting stack.filename are
% the names of the files each function call occurred, stack.name are the
% names of each (sub)function, which we do not know or want to filter by.
[filepaths filenames] = cellfun(@fileparts, {stack.file}, 'UniformOutput', 0);
[stack.filename] = filenames{:};
% Pop all internal delegating assert calls from the stack. Assumes that we
% are getting called through a chain of files named assert, assert_* or
% fail. Stop at the first item not one of the list names.
filtered_files = {'assert_true', ...
                  'assert_false', ...
                  'assert_equals', ...
                  'assert_not_equals', ...
                  'assert_empty', ...
                  'assert_not_empty', ...
                  'assert_error', ...
                  'assert_warning', ...
                  'assert_equals_withequalnans', ...
                  'assert_not_equals_withequalnans', ...
                  'abstract_assert_equals', ...
                  'fail'};
while ~isempty(stack) && any(strcmpi(stack(1).filename, filtered_files))
    stack(1)=[];
end

% might also have been called from the MATLAB console
if isempty(stack)
   stack(1).file = 'MATLABConsole';
   stack(1).line = NaN;
end

% Build up the stack trace from here.
stacktrace = '';
for i = 1:length(stack)
    stacktrace = [stacktrace, ...
        sprintf('\n  In %s at line %d.', stack(i).file, stack(i).line)];  %#ok<AGROW>
end;

% throw error
error(['MLUNIT FAILURE:Traceback (most recent call first):', ...
   stacktrace, ...
   msg_string]);
