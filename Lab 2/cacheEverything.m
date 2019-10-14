% Caches All Data Files as ETable for Faster Operation.
%
% If 'recache' is true, all existing cache files will be ignored and 
% ETables will be reconstructed and cached for every file.
function cacheEverything(recache)
    if nargin < 1
        recache = true;
    end
    
    ETable.CacheDirectory("RectData", ETOptions("m"), recache, true);
    ETable.CacheDirectory("RotData", ETOptions("rad"), recache, true);
end