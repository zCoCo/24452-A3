% Caches All Data Files as ETable for Faster Operation.
%
% If 'recache' is true, all existing cache files will be ignored and 
% ETables will be reconstructed and cached for every file.
function cacheEverything(recache)
    if nargin < 1
        recache = true;
    end
    
    % Cache all frequency files:
    ETable.CacheDirectory(fullfile("RectData","Exp3"), freq_ETOptions("m"), recache, true, "txt", "frf_");
    ETable.CacheDirectory(fullfile("RotData","Exp3"), freq_ETOptions("rad"), recache, true, "txt", "test");
end