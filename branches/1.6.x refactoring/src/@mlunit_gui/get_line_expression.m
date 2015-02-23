function expression = get_line_expression(self) %#ok
%mlunit_gui/get_line_expression returns the regular expression a line
%of the stack trace of the error message.
%
%  Example
%  =======
%  The method is internal to the mlUnit framework and should not be called
%  directly.
%
%  See also mlunit_gui, mlunit_gui/GUI,
%           mlunit_gui/SHORTEN_ERROR_TEXT. 

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: get_line_expression.m 166 2007-01-04 21:19:31Z thomi $

expression = 'In ([\w\ \.,$&/\\:@]*.m) at line (\w*)';