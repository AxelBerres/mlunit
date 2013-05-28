function assert_equals_withequalnans(expected, actual, varargin)
%ASSERT_EQUALS_WITHEQUALNANS Raise an error if two expressions differ.
%  ASSERT_EQUALS_WITHEQUALNANS works like ASSERT_EQUALS, but uses
%  isequalwithequalnans() rather than isequal() to determine equality.
%  That is why NaN values will be considered equal.
%
%  If EXPECTED or ACTUAL contain actual NaN or Inf values, tolerance
%  checking will not occur, but isequalwithequalnans will be used.
%  Only if EXPECTED and ACTUAL are both finite will tolerance checking
%  occur.
%
%  See also  FAIL, ASSERT_EQUALS, ASSERT_NOT_EQUALS_WITHEQUALNANS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 2
   fail('assert_equals_withequalnans: Not enough input arguments.');
end

abstract_assert_equals(true, true, expected, actual, varargin{:});
