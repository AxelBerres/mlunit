% Stub tempname that returns the same ("unique") temporary directory for successive calls.
function outpath = tempname

   persistent pathname;
   if isempty(pathname)
      pathname = fullfile(tempdir, ['tp' strrep(char(java.util.UUID.randomUUID),'-','_')]);
   end
   
   outpath = pathname;
