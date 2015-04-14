%Generate a string marking differences between two strings
%  M = MARK_STRING_DIFFERENCES(S1, S2) compares strings S1 and S2 and returns M,
%  a string containing difference markers (^) where single characters of the two
%  input strings differ. M will have the longer length of s1 and s2.
%
%  Can not (yet) detect character deletions or insertions. In these cases, all
%  characters starting from the difference will probably be marked as different.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function marker = mark_string_differences(s1, s2)

error(nargchk(2, 2, nargin, 'struct'));
if ~ischar(s1), error('s1 argument need be char'); end
if ~ischar(s2), error('s2 argument need be char'); end

common_length = min(numel(s1), numel(s2));
marker_length = max(numel(s1), numel(s2));

% start marker filled with spaces
marker = repmat(' ', 1, marker_length);

% mark char differences across the length common to both strings
marker(s1(1:common_length) ~= s2(1:common_length)) = deal('^');

% mark as different where one string is longer than the other
marker(common_length+1:marker_length) = deal('^');
