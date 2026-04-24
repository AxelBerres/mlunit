%Build a single stacktrace string out of a stack structure.
%  If there are stack items at all, start with a leading newline.
%  stack is the stack structure as returned by lasterror().stack or dbstack().

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function stackstring = mlunit_print_stack(stack, with_links, abbreviate)

if nargin < 3 || isempty(abbreviate), abbreviate = mlunit_param('abbrev_trace'); end
if nargin < 2 || isempty(with_links), with_links = mlunit_param('linked_trace'); end

stackstring = '';
for i = 1:size(stack, 1)
    stackstring = sprintf('%s\n%s', ...
        stackstring, ...
        loc_print_stackline(stack(i), abbreviate, with_links));
end

% Build a single stacktrace line for a single stacktrace item.
%   stackitem has fields as returned by lasterror().stack or dbstack().
function stackline = loc_print_stackline(stackitem, abbreviate, with_links)

display_name = stackitem.file;
if abbreviate
    [~, filename, ext] = fileparts(stackitem.file);
    display_name = [filename ext];
end

if with_links
    hrefvalue = sprintf('matlab:opentoline(''%s'',%d)', ...
        stackitem.file, stackitem.line);
    stackline = sprintf('In <a href="%s">%s</a> at line %d', ...
        hrefvalue, display_name, stackitem.line);
else
    stackline = sprintf('In %s at line %d', ...
        display_name, stackitem.line);
end
