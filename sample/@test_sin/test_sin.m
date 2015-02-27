function self = test_sin(name)
%test_sin constructor.
%
%  Class Info / Example
%  ====================
%  The class test_sin is the fixture for all tests for all sample tests of 
%  sin function. The constructor shall not be called directly, but through
%  a test runner.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: test_sin.m 17 2006-05-26 16:23:58Z thomi $

tc = test_case(name);
self = class(struct([]), 'test_sin', tc);