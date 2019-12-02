% Loads and Formats Data as an ETable from the File at Address 'addr' which has
% displacement units of 'xunits' (SI base units, so "m" or "rad")
function T = load_data(addr, xunits)
    T = ETable.CachedLoad(addr, ETOptions(xunits));
    % Rename Poorly Named Columns:
    T.rename('t', 'Time [s]');
    T.rename('F', 'Force [N]');

    % Update to SI Base Units:
    if xunits == "m" % Rectilinear:
        scaling = 1e-3; % mm -> m
    else % Torsional:
        scaling = 1; % keep as rad
    end
    for i = 1:3
        T.edit(char("x"+i), T.get(char("x"+i)) * scaling);
        T.rename(char("x"+i), char("Displacement "+i+" ["+xunits+"]"));
        T.edit(char("v"+i), T.get(char("v"+i)) * scaling);
        T.rename(char("v"+i), char("Velocity "+i+" [$^{"+xunits+"}/_s$]"));
        T.edit(char("a"+i), T.get(char("a"+i)) * scaling);
        T.rename(char("a"+i), char("Acceleration "+i+" [$^{"+xunits+"}/_{s^2}$]"));
    end
end