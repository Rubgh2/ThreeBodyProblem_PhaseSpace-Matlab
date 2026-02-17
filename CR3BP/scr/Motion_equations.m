function dxdt = Motion_equations(t, xx, mu)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    % Motion_equations - Derivatives for the planar CR3BP.
    % 
    % INPUTS:
    % 
    %   t - time (not used but required by ODE solvers)
    %   xx - state vector [x; y; vx; vy]
    %   mu - mass parameter
    % 
    % OUTPUT:
    %  
    %   dxdt - derivative vector [vx; vy; ax; ay]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % r_i is the distance to the i-th primary body.
    r1 = sqrt((xx(1) + mu)^2 + xx(2)^2);
    r2 = sqrt((xx(1) - (1 - mu))^2 + xx(2)^2);


    dxdt = zeros(4,1);
    % ˙x 
    dxdt(1) = xx(3);  
    % ˙y 
    dxdt(2) = xx(4);  
    % ˙˙x
    dxdt(3) = -(1 - mu)*(xx(1) + mu)/r1^3 - mu*(xx(1) - (1 - mu))/r2^3 + xx(1) + 2*xx(4);     
    % ˙˙y
    dxdt(4) = -(1 - mu)*xx(2)/r1^3 - mu*xx(2)/r2^3 + xx(2) - 2*xx(3); 
end 