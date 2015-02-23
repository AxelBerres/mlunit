function meths = get_methods(self)
%mlunit_reflect/get_methods returns the list of methods of the 'reflected' class.
%
%  Example
%  =======
%         r = mlunit_reflect('test_case');
%         get_methods(r);           % Returns a cell array with all methods
%                                   % of the class test_case
%
%  See also MLUNIT_REFLECT.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: get_methods.m 23 2006-05-26 23:32:58Z thomi $

meths = methods(self.class_name);
% enforce cell array, even if empty
if isempty(meths), meths = {}; end
% delete constructor method
meths(strcmp(self.class_name, meths)) = [];
