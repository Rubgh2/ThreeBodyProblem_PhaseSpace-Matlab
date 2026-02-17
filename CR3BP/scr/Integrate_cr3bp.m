function X = Integrate_cr3bp(tspan, x0, mu)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % integrate_cr3bp - Solve CR3BP ODE for given initial conditions.
    % 
    % INPUTS:
    %   
    %   tspan - vector of times to evaluate solution.
    %   x0    - initial state [x; y; vx; vy].
    %   mu    - mass parameter.
    %
    % OUTPUT:
    %
    %   X     - trajectory matrix [x, y, vx, vy] at each time in tspan.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options = odeset('RelTol',1e-8,'AbsTol',1e-10);
[~, X] = ode113(@(t,x) Motion_equations(t,x,mu), tspan, x0, options);
end