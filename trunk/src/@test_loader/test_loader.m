function self = test_loader
%Collection of stateless loading methods.
%
%  See load_tests_from_mfile, load_tests_from_test_case

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_loader.m 35 2006-06-11 16:37:12Z thomi $

self = class(struct(), 'test_loader');
