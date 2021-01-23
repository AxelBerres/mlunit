% Run only a single test out of a function test suite.
%
% Specify a specific function of a function test suite file to be run.
% This will also run (suite_) set_up/tear_down functions as appropriate, but will not
% run other tests of the suite.
%
% The input argument must be a char array in the format '<suite>.<test>', where
% <suite> is the name of a test suite, and <test> is the name of a test in that suite.
%
% Example:
% mlunit_single('test_mlunit_param.test_single_undefined')
% 
% See also mlunit_gui, mlunit_suite_runner

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function mlunit_single(suitetest)

mlunit_narginchk(1, 1, nargin);

if isempty(suitetest) || ~ischar(suitetest)
    error('MLUNIT:inputString', 'Argument must be a non-empty char array.');
end

occurences = numel(strfind(suitetest, '.'));
if 1 ~= occurences
    error('MLUNIT:inputString', 'Argument must be in the form ''suitename.testname''.');
end

suite_runner = add_listener(mlunit_suite_runner, mlunit_progress_listener_console);
run_suite_collection(suite_runner, {suitetest});
