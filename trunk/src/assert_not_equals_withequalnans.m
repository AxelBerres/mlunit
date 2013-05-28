function assert_not_equals_withequalnans(expected, actual, varargin)
%ASSERT_NOT_EQUALS_WITHEQUALNANS Raise an error if two expressions evaluate
%to the same.
%  ASSERT_NOT_EQUALS_WITHEQUALNANS works exactly like ASSERT_NOT_EQUALS, but in
%  the background uses isequalwithequalnans() rather than isequal() to determine
%  equality. That is why NaN values will be considered equal.
%
%  If EXPECTED or ACTUAL contain actual NaN or Inf values, tolerance
%  checking will not occur, but isequalwithequalnans will be used.
%  Only if EXPECTED and ACTUAL are both finite will tolerance checking
%  occur.
%
%  See also ASSERT_EQUALS, ASSERT_EQUALS_WITHEQUALNANS

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author$
%  $Id$

if nargin < 2
   fail('assert_not_equals_withequalnans: Not enough input arguments.');
end

abstract_assert_equals(true, false, expected, actual, varargin{:});
