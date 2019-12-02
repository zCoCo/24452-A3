% Loads and Formats Data as an ETable from the File at Address 'addr' which has
% displacement units of 'xunits' (SI units, so "mm" or "rad")
function T = load_freq(addr, xunits)
    T = ETable.CachedLoad(addr, freq_ETOptions(xunits));
    % Rename Poorly Named Columns:
    T.rename('f', 'Frequency [Hz]');
end