function [self, result] = run(self, result)
%test_case/run executes the test case and saves the results in result.
%
%  Example
%  =======
%  There are two ways of calling run:
%
%  1) [test, result] = run(test) uses the default test result.
%
%  2) [test, result] = run(test, result) uses the result given as
%     paramater, which allows to collect the result of a number of tests
%     within one test result.
%
%  See also TEST_CASE.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  §Author: Thomas Dohmke <thomas@dohmke.de> §
%  $Id: run.m 249 2007-01-26 22:59:59Z thomi $

if (nargin == 1)
    result = default_test_result(self);
end;

% reload test case file if modified in the same GUI session, e.g. during
% debugging
rehash;

result = start_test(result, self);
try
    % buffer parameter configuration
    previous_config = mlunit_param();

    % execute set_up fixture
    ok = 0;
    try
        self = set_up(self);
        ok = 1;
    catch
        result = add_error_with_stack(result, self, lasterror);
    end;

    % execute test, only if set_up prevailed
    if ok
        ok = 0;
        try
            method = self.name;
            self = eval([method, '(self)']);
            ok = 1;
        catch
            err = lasterror;
            errmsg = err.message;
            failure = strcmp(err.identifier, 'MLUNIT:Failure');
            if (failure)
                % filter up to 'MLUNIT FAILURE' string, which is used for masking actual error message
                failurepos = strfind(errmsg, 'MLUNIT FAILURE:');
                result = add_failure(result, ...
                    self, ...
                    errmsg(failurepos(1) + 15:length(errmsg)));
            else
                if (~isfield(err, 'stack'))
                    err.stack(1).file = char(which(self.name));
                    err.stack(1).line = '1';
                    err.stack = vertcat(err.stack, dbstack('-completenames'));
                end;

                result = add_error_with_stack(result, self, err);
            end;
        end;
    end;
    
    % execute tear_down fixture in any case, even if set_up or test failed
    try
        self = tear_down(self);    
    catch
        result = add_error_with_stack(result, self, lasterror);
        ok = 0;
    end;

    % restore previous parameter configuration after test and fixtures finished
    mlunit_param(previous_config);

    if (ok)
        result = add_success(result, self);
    end;
catch
end;
result = stop_test(result, self);

