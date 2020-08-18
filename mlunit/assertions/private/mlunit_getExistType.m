%MLUNIT_GETEXISTTYPE Get a text representation for an exist output value
%  S = MLUNIT_GETEXISTTYPE(V) yields a string that describes the meaning of V,
%  which is one of the return values of MATLAB's exist function.

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.

function typeString = mlunit_getExistType(existValue)
   switch existValue
      case 0
         typeString = 'missing';
      case 1
         typeString = 'a variable';
      case 2
         typeString = 'a file';
      case 3
         typeString = 'a MEX-file';
      case 4
         typeString = 'a Simulink model';
      case 5
         typeString = 'a built-in MATLAB function';
      case 6
         typeString = 'a P-code file';
      case 7
         typeString = 'a folder';
      case 8
         typeString = 'a Java class';
      otherwise
         typeString = sprintf('an unknown entity (%g)', existValue);
   end
