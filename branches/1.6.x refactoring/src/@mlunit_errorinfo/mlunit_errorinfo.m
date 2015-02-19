%Information about one error. Formattable.
%  This is very similar to the error struct returned by lasterror or MException.
%  In fact, you need to provide such an error struct as argument. Use this
%  class's methods to determine whether the error represent an mlUnit failure or
%  a proper error, or to easily obtains a printable representation including
%  message and stack.
%  
%  obj = mlunit_errorinfo(errorinfo) instanciates an object based on error
%  information in errorinfo. errorinfo must be a scalar struct with field
%  'message'. It can (and probably should) also contain fields 'identifier' and
%  'stack', the latter being a struct array with fields 'file', 'line', and
%  'name'.
%
%  obj = mlunit_errorinfo(errorinfo, additional_cause) does the same, but adds
%  the string additional_cause to the front of the error message.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function self = mlunit_errorinfo(errorinfo, additional_message)

error(nargchk(1, 2, nargin, 'struct'));

if ~isstruct(errorinfo) || ...
        numel(errorinfo)~=1 || ...
        ~isfield(errorinfo, 'message')
    error('errorinfo argument need be scalar struct with at least a field of name message');
end

if nargin<2, additional_message=''; end
if ~ischar(additional_message)
    error('additional_message argument need be char');
end

% Handle each relevant field, in order to only store relevant fields
self = struct();
self.additional_cause = additional_message;
self.err = struct();

self.err.message = errorinfo.message;

self.err.stack = struct('file', {}, 'line', {}, 'name', {});
if isfield(errorinfo, 'stack')
    self.err.stack = errorinfo.stack;
end

self.err.identifier = '';
if isfield(errorinfo, 'identifier')
    self.err.identifier = errorinfo.identifier;
end

% instanciate
self = class(self, 'mlunit_errorinfo');
