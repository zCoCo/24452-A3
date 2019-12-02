% Returns the ETable Options to Load Data for frequency domain experiments 
% Given the String 'xunits' which is the units used by "x" for the 
% experiment type (SI units, so "rad" for torsional and "mm" for rectilinear).
function options = freq_ETOptions(xunits)
    if xunits == "mm"
        u_frf = "$^{mm}/_{N}$"; % FRF Amplitude Units
    else
        u_frf = "$^{rad}/_{Nm}$";
    end

    options = struct(...
        'isText', true, ...
        'ignoreLines', 21, ...
        ... % Variable Names for Each Column:
        'shortNames', ["f", "FRF_A1","FRF_A2","FRF_A3", "FRF_P1","FRF_P2","FRF_P3", "coh1","coh2","coh3", "note"], ...
        ... % Latex formated units for each column:
        'unitsList', ["Hz", u_frf,u_frf,u_frf, "rad","rad","rad", "","","", ""] ...
    );
end