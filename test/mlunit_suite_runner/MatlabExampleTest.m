classdef MatlabExampleTest < matlab.unittest.TestCase
    methods(Test)

        function doubleScalar(testCase)
            testCase.verifyEqual(MatlabExampleTest.doublethis(2), [2, 2])
        end

        function doubleVector(testCase)
            testCase.verifyEqual(MatlabExampleTest.doublethis([2, 3]), [2, 3, 2, 3])
        end

        function charVector(testCase)
            testCase.verifyEqual(MatlabExampleTest.doublethis('foo'), 'foofoo')
        end

        function fewInputs(testCase)
            testCase.verifyError(@()MatlabExampleTest.doublethis(), 'MATLAB:minrhs')
        end

        function skippedTest(testCase)
            assumeFail(testCase)
        end

    end

    methods(Static)
        function out = doublethis(in)
            out = repmat(in, 1, 2);
        end
    end
end
