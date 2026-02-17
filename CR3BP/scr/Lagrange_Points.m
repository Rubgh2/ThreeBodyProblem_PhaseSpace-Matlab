function lagrange_points = Lagrange_Points(mu)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Lagrange_Points: Calculate the Lagrange points for the planar CR3BP
    %
    % INPUT:
    %    mu               - Mass parameter of the system (mu = m2 / (m1 + m2))
    %
    % OUTPUT:
    %    lagrange_points  - 5x2 matrix with (x, y) coordinates of L1-L5
    %
    % NOTES:
    %    - L1, L2, L3 lie on the x-axis.
    %    - L1: between the two primary bodies (initial guess: 0.8)
    %    - L2: right of the secondary body (initial guess: 1.2)
    %    - L3: left of the primary body (initial guess: -1.0)
    %    - L4 and L5 form equilateral triangles with the primaries
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Function for L1, L2, L3
    f_L = @(x) x - (1 - mu)*(x + mu)/((x + mu)^2)^(3/2) - mu*(x - (1 - mu))/((x - (1 - mu))^2)^(3/2);
    
    % Initial guesses for L1-L3
    x_guess = [0.8, 1.2, -1.0]; 
    x_points = zeros(1,5);       
    
    % Solve for L1, L2, L3 x-coordinates
    for k = 1:3
        x_points(k) = fzero(f_L, x_guess(k));
    end
    
    % L4 and L5 x-coordinates (fixed)
    x_points(4) = 0.5 - mu;
    x_points(5) = 0.5 - mu;
    
    % Corresponding y-coordinates
    y_points = [0, 0, 0, sqrt(3)/2, -sqrt(3)/2];
    
    % Combine into 5x2 matrix
    lagrange_points = [x_points(:), y_points(:)];

end