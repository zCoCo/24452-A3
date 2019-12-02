% Performs a Sine-Sweep on a System with the Given Dynamic Parameters of
% Mass, m, Stiffness, k, and Damping, c (or their rotational equivalents)
% between frequencies f_min and f_max [Hz] for a forcing function with 
% amplitude F0.
% 
% Produces the FRF plot using N sample points between f_min and f_max.
% If not given, N=250.
function FRF = sine_sweep_sim(m,k,c, F0, f_min, f_max, N)
    if nargin < 7
        N = 250;
    end

    q0 = [0 0]; % Simulate all systems with initial condionts of 0 (x0,v0)
    tf = 40; % [s] Time to run each simulation for.
    
    FRF.freq = linspace(f_min,f_max, N); % Frequencies to test
    FRF.amp = zeros(size(FRF.freq));
    FRF.phase = zeros(size(FRF.freq));
    
    for i = 1:numel(FRF.freq) % For every frequency in range
        f = FRF.freq(i); % note: [Hz]
        u = @(t) F0 .* sin(2*pi*f.*t); % Set up forcing function
        
        % Simulate the second order system vibrating with forcing function:
        [xs, ~, ts, us] = forced_vib(m,k,c, u, q0, tf);
        
        % Extract One Steady-State Cycle:
        T = 1/f;
        i_0 = find(ts>0.75*tf & abs(us) < 0.1*F0); i_0 = i_0(1); % start index of cycle (choose when amp is small to avoid cutting near/on a peak)
        i_f = find(ts>ts(i_0)+T); i_f = i_f(1);% end index of cycle
        t_cyc = ts(i_0:i_f); % time points across selected cycle
        x_cyc = xs(i_0:i_f); % output points
        u_cyc = us(i_0:i_f); % input points
        
        % Compute FRF Properties:
        A_x = ( abs(max(x_cyc)) + abs(min(x_cyc)) ) / 2; % wave amplitude of output
        A_u = ( abs(max(u_cyc)) + abs(min(u_cyc)) ) / 2; % wave amplitude of input
        FRF.amp(i) = A_x / A_u; % Amplitude ratio
        
        Dt = t_cyc(u_cyc==max(u_cyc)) - t_cyc(x_cyc==max(x_cyc));
        FRF.phase(i) = 2*pi*Dt(1)/T;
    end
end