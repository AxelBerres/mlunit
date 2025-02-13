classdef MatlabExampleParameterized < matlab.unittest.TestCase
    methods(Test)

        function demonstrateFailure(testCase)
            testCase.verifyEqual(mlunit_param('bla'), 3)
        end

        function demonstrateError(testCase)
            error('HEY:THERE', 'something went wrong');
        end

        function demonstratePass(testCase)
            testCase.verifyEqual(3, 3)
        end

        function demonstrateSkip(testCase)
            assumeFail(testCase)
        end

    end
end
