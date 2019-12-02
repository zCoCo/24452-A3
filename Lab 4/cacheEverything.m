% Caches All Data Files as ETable for Faster Operation.
%
% If 'recache' is true, all existing cache files will be ignored and 
% ETables will be reconstructed and cached for every file.
function cacheEverything(recache)
    if nargin < 1
        recache = true;
    end
    
    % Cache All Displacement Experiments:
    ETable.CacheDirectory("RectData", ETOptions("m"), recache, true, ["xlsx", "txt", "csv"], "", "Exp2_");
    ETable.CacheDirectory("RotData", ETOptions("rad"), recache, true, ["xlsx", "txt", "csv"], "", "Exp2_");
    
    % Cache All Frequency Domain Experiments:
    ETable.CacheDirectory("RectData", freq_ETOptions("mm"), recache, true, ["xlsx", "txt", "csv"], "Exp2_");
    ETable.CacheDirectory("RotData", freq_ETOptions("rad"), recache, true, ["xlsx", "txt", "csv"], "Exp2_");
end