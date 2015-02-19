%Build a single stactracke string out of a stack structure.
%  stack is the stack structure as returned by lasterror().stack or dbstack().
function stackstring = mlunit_print_stack(stack)

stackstring = '';
for i = 1:size(stack, 1)
    stackstring = sprintf('%s\nIn %s at line %d', ...
        stackstring, ...
        stack(i).file, stack(i).line);
end
