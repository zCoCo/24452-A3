% Performs Logarithmic Decrement for a Signal Experiencing
% Free-Vibration.
% Returns the Damping Ratio, z, for the Data in the Column with the
% Given Short Name, colY, as a Function of the Column with the
% Given Short Name, colX, over the given range. Range must only
% include one section of free-oscillation and nothing else.
% Returns damping ratio, z, the natural frequency wn, equilibrium 
% position (steady-state value), and the location of all the peaks 
% identified as a struct with parameters X and Y.
% Can be tuned to reject more peaks by adjusting the quantile
% fraction chosen in prominences selection (default is 0.5).
function [z, wn, peaks, equilibrium] = logdec(obj, colX,colY, range, tuning)
    xs = obj.get(char(colX));
    ys = obj.get(char(colY));

    if nargin > 3
        xs = xs(range);
        ys = ys(range);
    end
    if nargin < 5
        tuning = 0.5;
    end

    peaks = struct('X',[],'Y',[]);
    % Perform a basic first pass to assess the data:
    peaks.Y = findpeaks(ys, xs); % Find all local maxima

    if(numel(peaks.Y) < 3)
        error('Not enough peaks to perform logarithmic decrement.');
    end

    % Only select peaks which have gone down and back up again by
    % a selected prominence value (to avoid detecting noise at the
    % peaks as multiple separate peaks).
    equilibrium = ys(end); % Assumed Steady-state value.
    peaks.Y = peaks.Y(peaks.Y > equilibrium); % Filter out noise peaks near minima
    prominence = peaks.Y - equilibrium; % Half-Prominence of all peaks
    % Take a prominence (mean of the half-prominences), but make 
    % sure there end up being at least 4 peaks left:
    prominence = min( mean([quantile(prominence,tuning), mean(prominence)]), prominence(4) );
    % Reassess Peaks:
    [peaks.Y, peaks.X] = findpeaks(ys, xs, 'MinPeakProminence',prominence);
    % Filter out really obvious noise peaks near minima (there
    % really shouldn't be any here at this point but just in case):
    valid = peaks.Y > equilibrium;
    peaks.Y = peaks.Y(valid);
    peaks.X = peaks.X(valid);
    Td = mean(diff(peaks.X)); % Underestimate on Average Damped Period

    [peaks.Y, peaks.X] = findpeaks(ys, xs, 'MinPeakProminence',prominence, 'MinPeakDistance',0.6*Td); % just over half-period
    % Filter out really obvious noise peaks near minima (there
    % really shouldn't be any here at this point but just in case):
    valid = peaks.Y > equilibrium;
    peaks.Y = peaks.Y(valid);
    peaks.X = peaks.X(valid);

    % Do one final pass filtering out any multiple recognitions of
    % a peak when the signal is still at high amplitude (these can
    % make it through the above filters):

    % Perform Logarithmic Decrement:
    % Average across all possible spans with at least 3 peaks to 
    % try to eliminate effects of any errant peaks:
    if(numel(peaks.Y) < 3)
        warning('Not enough peaks to perform logarithmic decrement well.');
    end
    if(numel(peaks.Y) < 2)
        error('Not enough peaks to perform logarithmic decrement.');
    else
        zs = [];
        peaksRel = peaks.Y - equilibrium;
        for i = 2:numel(peaks.Y)
            d = log(peaksRel(1)/peaksRel(i)) / (i-1);
            zs(end+1) = d / sqrt(4*pi^2 + d^2);
        end

        % Choose the z from zs which creates an envelope that 
        % best fits the peaks (minimum least squared error):
        lses = []; % Least Squared Error of Each z value in zs
        for i = 1:numel(zs)
            lses(i) = sum((peaks.Y - envelope(peaks.X, zs(i))).^2);
        end
        [~, minIdx] = min(lses);
        z = zs(minIdx);

        % Collect Associated Values:
        Td = mean(diff(peaks.X)); % Average Damped Period
        wd = 2*pi/Td; % Damped Natural Frequency
        wn = wd / sqrt(1-z^2); % Natural Frequency
    end

    % Helper function that returns a function for plotting an 
    % envelope for a given z.
    function e = envelope(t,z)
        ttd = mean(diff(peaks.X)); % Average Damped Period
        wwd = 2*pi/ttd; % Damped Natural Frequency
        wwn = wwd / sqrt(1-z^2); % Natural Frequency
        e = (equilibrium + (peaks.Y(1)-equilibrium)*exp(-z.*wwn.*(t-peaks.X(1))))./sqrt(1-z^2);
    end
end