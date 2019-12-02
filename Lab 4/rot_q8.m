function rot_q8()
    %% SETUP:
    xunits = "rad";
    DOF = 2; % Number of degrees of freedom in the system.
    
    test = 1;
    while test <= 5
        disp("Test " + test + " . . .");
        response = input('Skip this test? Y/N', 's');
        if isempty(response) || upper(response(1)) == 'Y'
            test = test + 1;
        else

            %% LOAD DATA:
            data = load_data(fullfile("RotData/Exp4","Exp4_test"+test+".txt"), xunits);
            t = data.t;

            %% PLOT FFT:
            results = figure();

            time_plot = subplot(211); % Time-Domain Results
            time_phs = []; % Time-Domain plot handles
            time_startIdx = zeros(1,DOF); % Time-Domain selection window start indices
            time_finishIdx = zeros(1,DOF); % Time-Domain selection window start indices
            
            xlabel('Time [s]', 'Interpreter', 'latex');
            ylabel('Displacement [rad]', 'Interpreter', 'latex');

            freq_plot = subplot(212); % Frequency-Domain Results
            xlabel('Frequency [Hz]', 'Interpreter', 'latex');
            ylabel('Amplitude', 'Interpreter', 'latex');

            for i = 1:DOF
                y = data.get(char("x"+i));

                % Attempt to automatically select the active region:
                % find the index of the maximum amplitude
                [~, first_peak] = max(abs(y));
                % find first zero crossing after first peak:
                idx = (2:numel(y))';
                time_startIdx(i) = find(abs(diff(sign(y))) > 0 & idx > first_peak, 1);
                % find steady state (1% settling):
                ymax = max(y);
                yinf = y(end);
                time_finishIdx(i) = find(abs((y - yinf) / (ymax - yinf)) > 0.01/2, 1, 'last'); % find index of last point outside of envelope
                % grab indices in range:
                indx = time_startIdx(i):time_finishIdx(i);
                % plot and highlight results:
                fig = figure();
                plot(t,y);
                yy = y(indx);
                tt = t(indx);
                hold on
                plot(tt,yy,'r');
                hold off


                % Manually reselect active region if neccessary:
                drawnow;
                response = input('Manually reselect range? Y/N', 's');
                if(~isempty(response) && upper(response(1)) == 'Y')
                    plot(t,y);
                    title("Select the active region (after disks/cart is released up to steady state) . . .");
                    drawnow;
                    figure(fig);
                    [x, ~] = ginput(2);
                    time_startIdx(i) = find(t>x(1), 1,'first');
                    time_finishIdx(i) = find(t<x(2), 1,'last');
                    indx = time_startIdx(i):time_finishIdx(i);
                    yy = y(indx);
                    tt = t(indx);
                    hold on
                    plot(tt,yy,'r');
                end

                % Re-zero time range:
                tt = tt-tt(1);

                % Plot that region:
                figure(results);
                subplot(time_plot);
                hold on
                time_phs(i) = plot(tt,yy);

                % New frequency vector
                ff = 0:1/tt(end):(length(tt)-1)/tt(end);

                figure(results);
                subplot(freq_plot);
                hold on
                plot(ff, abs(fft(yy))/(length(fft(yy))/2));
                xlim([0 10]);
                title('Select Resonant Frequency Peaks . . .');

                drawnow;
                % Identify the Resonant Frequencies:
                for j = 1:DOF
                    [f_res,~] = ginput(1);
                    if i == 1
                        level = 'bottom';
                    else
                        level = 'top';
                    end
                    ETable.vline(f_res, "$\quad\omega_{"+i+",\;"+j+"}\;=\;" + sprintf('%0.4f', f_res) + "\quad$", 'auto', level);
                end
            end

            subplot(time_plot);
            title('');
            legend({char("Test "+test+" DOF 1"), char("Test "+test+" DOF 2")}, 'Interpreter', 'latex');

            subplot(freq_plot);
            title('');
            legend({char("Test "+test+" DOF 1"), char("Test "+test+" DOF 2")}, 'Interpreter', 'latex');

            % Phase shift results if necessary (for minor adjustments when selection was slightly off):
            response = input('Phase shift results? Y/N', 's');
            if isempty(response) || upper(response(1)) == 'Y'
                disp("'w' to shift DOF 1 left, 's' to shift DOF 1 right. 'a' to shift DOF 2 left. 'd' to shift DOF 2 right.");
                disp("'f' to finish");
                while response ~= 'f'
                    response = input(response, 's');
                    if isempty(response)
                        response = '';
                    else
                        response = response(1);
                    end
                    plot_idx = 0;
                    shift = 0; % amount to shift plot by
                    switch response
                        case 'w'
                            plot_idx = 1;
                            shift = +1;
                        case 's'
                            plot_idx = 1;
                            shift = -1;
                        case 'a'
                            plot_idx = 2;
                            shift = +1;
                        case 'd'
                            plot_idx = 2;
                            shift = -1;
                    end
                    shift = shift * 10;
                    if shift ~= 0
                        y = data.get(char("x"+plot_idx));
                        time_startIdx(plot_idx) = time_startIdx(plot_idx) + shift;
                        time_finishIdx(plot_idx) = time_finishIdx(plot_idx) + shift;
                        indx = time_startIdx(plot_idx):time_finishIdx(plot_idx);
                        yy = y(indx);
                        tt = t(indx);
                        tt = tt-tt(1);
                        set(time_phs(plot_idx), 'XData', tt);
                        set(time_phs(plot_idx), 'YData', yy);
                        refreshdata;
                        drawnow;
                    end
                end
            end
            
            response = input('Save these results? Y/N', 's');
            if isempty(response) || upper(response(1)) == 'Y'
                saveas(gcf, mfilename+"_test"+test+".png", 'png');
                test = test + 1;
            else
                response = input('Skip this test or redo? S/R', 's');
                if isempty(response) || upper(response(1)) == 'S'
                    test = test + 1;
                end
            end
        end
    end
end