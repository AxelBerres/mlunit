%STRREP_FIRST Replace prefix with another.
%  S = STRREP_FIRST(TEXT,OFFENDER,REPLACEMENT) replaces the string OFFENDER in
%  string TEXT with the string REPLACEMENT, but only for its first occurrence
%  if it starts right at TEXT's beginning.
%
%  TEXT may be a cell array or a scalar string.
%
%  See also strrep, strmatch.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Id$

function result = strrep_first(text, offender, replacement)

error(nargchk(3,3,nargin,'struct'));
if ~ischar(text) && ~iscell(text), error('text need be char or cell'); end
if ~ischar(offender), error('offender need be char'); end
if ~ischar(replacement), error('replacement need be char'); end

wrapcell = ischar(text);
if wrapcell, text = {text}; end
result = cellfun(@(t)loc_strrep_first_single(t,offender,replacement),text,'UniformOutput', false);
if wrapcell, result = result{1}; end


function result = loc_strrep_first_single(text, offender, replacement)

    if ~isempty(strmatch(offender, text))
        result = [replacement text(length(offender)+1:end)];
    else
        result = text;
    end
