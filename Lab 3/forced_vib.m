% Simulates the vibrations of a 1-DOF 2nd order system up to the final time
% tf, subject to initial conditions q0 = [x0,v0], given its three 
% coefficient dynamic properties (m,k,c) or their rotational equivalents 
% (J,k,b) and a forcing function, u(t).
% Returns a time-series of the displacement and velocity response as well
% as their corresponding time vector.
function [xs, vs, ts, us] = forced_vib(m,k,c, u, q0, tf)
    % State-Space Representation of Second Order System:
    function dqdt = secondorder(t,q, m,c,k, u)
        A = [0 1; -k/m -c/m];
        B = [0; 1/m];
        dqdt = A*q + B*u(t);
    end

    ts = 0:0.001:tf;
    [ts,q] = ode45(@(t,q) secondorder(t,q, m,c,k,u),ts,q0);
    
    % Extract Results:
    xs = q(:,1);
    vs = q(:,2);
    % Retroactively Compute Forcing Function for All Points:
    us = u(ts);
end
