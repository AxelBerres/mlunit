%Free error message of leading 'Error:' or 'Error using' lines.
%  Those are MATLAB byproducts of using lasterror. lasterror adds a line to the
%  front of the error message. For runtime errors, this is 'Error using',
%  followed by the function name where the error occurred. For syntax errors,
%  this is 'Error:' followed by the function and line where the error occurred.
%  Strangely, for syntax errors these extra information are not included in the
%  stack. filter_lasterror_wraps therefore parses the extra line, and adds the
%  information as stack item.
%  filter_lasterror_wraps works on the internally buffered error information
%  that you provided in mlunit_errorinfo's constructor.
%
%  [message, stack] = filter_lasterror_wraps(self) returns the cropped message,
%  and the stack structure, that may be enhanced in case of a syntax error.
%
%  This method is expected to be private. Rather use get_message_with_stack
%  instead.
%
%  See also test_filter_lasterror, get_message_with_stack

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function [message, stack] = filter_lasterror_wraps(self)

% use verbatim values as defaults
message = self.err.message;
stack = self.err.stack;

% lasterror wraps runtime errors with either:
%    'Error using ==>...' on R2006b to R2010b, or
%    'Error using <a href...' from R2011b on
regexp_runtime_err = ['^Error using ' ...   % always starts with 'Error using'
                      '(==>|<a href)' ...   % '==>' before R2011b, as <a> after
                      '[^\n]*' ...          % skip anything on this line
                      '\n(.*)'];            % capture the next line(s)
num_captures_runtime_err = 2;               % 2 capture groups if successfull
                  
% lasterror wraps syntax errors really awkwardly across the releases
% for details, see test_mlunit_errorinfo
regexp_syntax_err = ['^Error: ' ...         % starts with 'Error:'
                     '<a[^>]*>' ...         % puts an anchor around the file
                     'File: ' ...
                     '<?' ...               % Jenkins wraps the file in <>
                     '([\w\ \.,$&\/\(\)\\:@]+.[mp])' ...  % file name or path
                     '>?' ...               % Jenkins closing wrap
                     ' Line: (\d+)' ...
                     ' Column: (\d+)' ...
                     '.*' ...               % any further character
                     '(<\/a>\n|\n<\/a>)' ...% anchor closing tag may be before or after newline
                     '(.*)'];               % this is the actual message
num_captures_syntax_err = 5;                % 5 capture groups if successfull

% run both 
tokens_runtime = regexp(message, regexp_runtime_err, 'tokens', 'once');
tokens_syntax = regexp(message, regexp_syntax_err, 'tokens', 'once');

% match either a runtime or a syntax error
if length(tokens_runtime) == num_captures_runtime_err
    message = char(tokens_runtime(2));
elseif length(tokens_syntax) == num_captures_syntax_err
    message = char(tokens_syntax(5));
    file = char(tokens_syntax(1));
    line = str2double(char(tokens_syntax(2)));
    
    % see if we can resolve the full file path
    fullname = which(file);
    if isempty(fullname), fullname = file; end
    
    % push reconstructed call location onto stack
    stackitem = struct('file', {fullname}, 'line', {line}, 'name', {file});
    stack = [stackitem; stack];
else
    % unrecognized message format: leave message and stack as they are
end

% trim leading and trailing whitespace
message = strtrim(message);

% might not contain any actual message
if isempty(message)
    message = '(no message available)';
end

% set additional error message before the proper message as cause
if ~isempty(self.additional_cause)
    message = [self.additional_cause sprintf('\n') message];
end
