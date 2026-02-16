function [D, D_past, D_future] = LDs(...
    dx, dy, tspan, init_condx, init_condy, ...
    mu, C, theta)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LDs Compute Lagrangian Descriptors (LD) for a 2D CR3BP grid
    %
    % INPUTS:
    %   dx, dy              - Number of grid points in x and y directions
    %   tspan               - 2-column matrix: [forward_times, backward_times]
    %   init_condx          - Vector of initial x coordinates of the grid
    %   init_condy          - Vector of initial y coordinates of the grid
    %   mu                  - Mass parameter of the CR3BP
    %   C                   - Jacobi constant
    %   theta               - Velocity angle (radians) used to initialize trajectories
    %   save_trajectory     - Boolean: whether to save selected trajectories
    %   traj_pos            - 2 × n_traj array with [row, col] indices of
    %                         trajectories to save or [] if save_trajectory==false
    %   base_path_data      - Path to the 'Data' folder where results will be saved
    %
    % OUTPUTS:
    %   D, D_past, D_future - dy × dx matrices containing the Lagrangian Descriptors
    %                         (log of the integrated trajectory arc-length)
    %
    % NOTES:
    %   - Uses parfor for parallel computation of trajectories
    %   - If save_trajectory is true, selected trajectories are stored in a struct
    %     array and saved to 'trajectories_theta_XXX.mat'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preallocate LD matrices
D         = zeros(dy, dx);
D_past    = zeros(dy, dx);
D_future  = zeros(dy, dx);

% ================= Main grid loop =================

for j = 1:dy

    % Row preallocation
    D_row        = zeros(1, dx);
    D_row_past   = zeros(1, dx);
    D_row_future = zeros(1, dx);

    % Parallel loop over x-index
    parfor i = 1:dx

        x_0 = init_condx(i);
        y_0 = init_condy(j);

        d1 = sqrt((x_0 + mu)^2 + y_0^2);
        d2 = sqrt((x_0 - (1 - mu))^2 + y_0^2);

        Omega = 0.5 * (x_0^2 + y_0^2) + (1-mu)/d1 + mu/d2;

        % Forbidden region
        if 2*Omega < C
            D_row(i)        = NaN;
            D_row_past(i)   = NaN;
            D_row_future(i) = NaN;
            continue;
        end

        % Velocity magnitude
        r   = sqrt(2*Omega - C);
        v_x = r * cos(theta);
        v_y = r * sin(theta);

        x0 = [x_0; y_0; v_x; v_y];

        % Integrate
        x_past   = Integrate_cr3bp(tspan(:,2), x0, mu);
        x_future = Integrate_cr3bp(tspan(:,1), x0, mu);

        % Combine trajectories
        x = [x_past(end:-1:2, :); x_future];

        % Compute arc-length
        dif_all    = diff(x);
        dif_past   = diff(x_past);
        dif_future = diff(x_future);

        d_all    = sum(vecnorm(dif_all,    2, 2));
        d_past   = sum(vecnorm(dif_past,   2, 2));
        d_future = sum(vecnorm(dif_future, 2, 2));

        D_row(i)        = log(d_all);
        D_row_past(i)   = log(d_past);
        D_row_future(i) = log(d_future);

    end % end parfor

    % Assign computed row
    D(j,:)        = D_row;
    D_past(j,:)   = D_row_past;
    D_future(j,:) = D_row_future;

end % end outer loop


end

 