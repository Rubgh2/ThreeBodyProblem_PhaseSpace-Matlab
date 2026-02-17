function Calculate_Plot_trajectories( ...
    init_condx, init_condy, mu, C, theta, tspan, traj_pos, ...
    base_path_data, base_path_im, ...
    plot_trajectories, save_image, ...
    X, Y, lagrange_points)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% 
% Calculate_Plot_trajectories:  
%      
%
%   This function integrates and plots trajectories for selected initial 
%   conditions on the grid, over the energetically viable 
%   region (where 2*V - C >= 0, shown in light blue; forbidden regions in white).
%   Trajectories are saved as CSV and plots as high-resolution PNG if requested.
%
%   Inputs:
%     init_condx    - Vector of x initial conditions (grid points)
%     init_condy    - Vector of y initial conditions (grid points)
%     mu            - Mass parameter 
%     C             - Jacobi constant for the current energy level
%     theta         - Direction 
%     tspan         - Time span matrix for integration 
%     traj_pos      - Nx2 matrix of grid indices
%     base_path_data - Base folder path to save trajectory CSV files
%     base_path_im   - Base folder path to save trajectory plot images
%     plot_trajectories - Boolean: true to generate plots
%     save_image    - Boolean: true to export plots as PNG 
%     X             - Meshgrid matrix of x coordinates
%     Y             - Meshgrid matrix of y coordinates
%     lagrange_points - Nx2 matrix with coordinates of L1–L5 points
%
%   Outputs:
%     None  saves CSV files and PNG images if requested)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for k = 1:size(traj_pos,1)
        
        %Initial position
        x_0 = init_condx(traj_pos(k,1));
        y_0 = init_condy(traj_pos(k,2));


        % Distances to primaries
        d1 = sqrt((x_0 + mu)^2 + y_0^2);
        d2 = sqrt((x_0 - (1 - mu))^2 + y_0^2);

        %Effective potential 
        Omega = 0.5 * (x_0^2 + y_0^2) + (1-mu)/d1 + mu/d2;
        
        if 2*Omega-C< -1e-12
             fprintf("Impossible initial condition at (%.4f, %.4f)\n", x_0, y_0)
             continue
        end
        %Velocity magnitude
        r   = sqrt(max(2*Omega - C,0));  %Numerical errors can result in complex numbers
        v_x = r * cos(theta);
        v_y = r * sin(theta);

        x0 = [x_0; y_0; v_x; v_y];

        %Integrate trajectory
        traj = Integrate_cr3bp(tspan(:,1), x0, mu);

        %Save trajectory
        name_traj_file = fullfile(base_path_data, ...
            sprintf('Trajectory_C_%.4f_theta_%.2f_Posx%.4f_Posy%.4f.csv', ...
            C, theta, x_0, y_0));

        writematrix(traj, name_traj_file);

        % =============================
        %           PLOT
        % =============================
        if plot_trajectories

            f=figure;
            % Calculate Omega on the grid
            Omega = 0.5 * (X.^2 + Y.^2) + (1-mu)./sqrt((X + mu).^2 + Y.^2) + mu./sqrt((X - (1-mu)).^2 + Y.^2);
    
            % Viable region 1; forbidden region 0 
            mask = double(2 * Omega - C >= 0);

            
            % Light blue viable region, white forbidden.
            pcolor(X, Y, mask);
            shading flat;
            colormap([1 1 1; 0.8 0.9 1]);  % [white; light blue]
            set(gca, 'Color', [1 1 1]);    

            xlabel('x_0','FontSize',16)
            ylabel('y_0','FontSize',16)

            title(sprintf('Trajectory - C = %.4f, \\theta = %.2f, (x,y)=(%.4f,%.4f)', ...
                C, theta, x_0, y_0))

            hold on

            % Primaries bodies
            plot(-mu, 0, 'ro', 'MarkerSize', 8)
            plot((1 - mu), 0, 'bo', 'MarkerSize', 8)

            % Lagrange Points
            plot(lagrange_points(:,1), lagrange_points(:,2), ...
                'k*','MarkerSize',10)

            % Trajectory 
            plot(traj(:,1), traj(:,2), ...
                'LineWidth',1.5,'Color','r')
            
            % fixed axes limits 
            xlim([min(X(:)) max(X(:))])
            ylim([min(Y(:)) max(Y(:))])

            hold off

            % Save images
            if save_image
                filename = fullfile(base_path_im, ...
                    sprintf('Trajectory_C_%.4f_theta_%.2f_Posx%.4f_Posy%.4f.png', ...
                    C, theta, x_0, y_0));

                exportgraphics(f, filename, ...
                    'Resolution',300)


            end
        end
    end
end
