function dq = secondorder(t,q, m,c,k)
    A = [0 1; -k/m -c/m];
    B = [0; 1/m];
    u = 0;
    dq = A*q + B*u;
end
