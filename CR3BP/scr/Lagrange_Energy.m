
function C_values = Lagrange_Energy(mu,lagrange_points)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Lagrange_Energy: Calculate the Jacobi constants for the Lagrange points
    %
    % INPUTS:
    %    - mu             : Mass parameter of the system (mu = m2 / (m1 + m2))
    %    - lagrange_points: 5x2 matrix with (x, y) coordinates of L1-L5
    %                       (calculated using Lagrange_Points function)
    %
    % OUTPUTS:
    %    - C_values       : 9-element vector containing Jacobi constants
    %                       at L1-L5 and their averages between consecutive points
    %
    % NOTES:
    %    - H_lagrange is the Hamiltonian at the Lagrange points (v=0)
    %    - Jacobi constant: C = -2*H
    %    - Means are calculated between consecutive points to sample intermediate energies
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Preallocate matrices
    C_lagrange = zeros(1, 5);
    H_lagrange = zeros(1, 5);

    % Calulate the Hamiltonian and Jacobi constant
    % using v=0 in Lagrange points.

    x = lagrange_points(:,1);
    y = lagrange_points(:,2);
    
    d1 = sqrt((x + mu).^2 + y.^2);
    d2 = sqrt((x - (1 - mu)).^2 + y.^2);
    
    H_lagrange = - (0.5*(x.^2 + y.^2) + (1 - mu)./d1 + mu./d2);
    C_lagrange = -2*H_lagrange;
    
    % Calculate means between consecutive points
    C_means = zeros(5,1);
    C_means(2:4) = (C_lagrange(1:3) + C_lagrange(2:4))/2;
    C_means(1) = 2*C_lagrange(1) - C_means(2);
    C_means(5) = 2*C_lagrange(4) - C_means(4);
    
    % Combine C_lagrange and C_means into final vector
    C_values = [C_means(1), C_lagrange(1), C_means(2), C_lagrange(2), ...
            C_means(3), C_lagrange(3), C_means(4), C_lagrange(4), C_means(5)];
end