function []=Plot_phase_space(X,Y,C,theta,D,D_past,D_future,...
            mu,lagrange_points,plt_phase_space,...
            plt_stb_man,plt_unstb_man, save_image,base_path_im)
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %   
    %   Plots the phase space corresponding to energy levels 
    %   of the input lagrange_points. 
    % 
    %   INPUTS: 
    %           X,Y - grid obtained in meshgrid 
    %           C - Jacobi constant 
    %           D - result of Lagragian Descriptors method 
    %           D_past - Lagrangian descriptors for past 
    %           D_future - Lagrangian descriptors for future 
    %           mu - mass parameter 
    %           lagrange_points - energy levels to draw 
    %           plt_phase_space - boolean; true if you want to draw the 
    %                             phase space 
    %           plt_stb_man - boolean; true if you want to draw 
    %                         stable manifold 
    %           plt_unstb_man - boolean; true if you want to draw 
    %                           unstable manifolds 
    %           save_image - boolean; true if you want to save the 
    %                        plots in the subfolder Images 
    %           base_path_im - path to save images 
    % 
    %   OUTPUT: 
    %           plots of the LDs method, stable and unstable manifolds 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ============================ Phase Space ============================
    if plt_phase_space      
        figure(1)

        h_pcolor = pcolor(X, Y, D);
        shading interp
        colorbar
        xlabel('x_0','FontSize',16)
        ylabel('y_0','FontSize',16)
        axis equal tight   
        title(sprintf('Phase space - C = %.4f, \\theta = %.2f', C, theta), 'FontSize',18)

        hold on

        % Plot primary bodies
        plot(-mu, 0, 'ro', 'MarkerSize', 8, 'DisplayName', 'Primary Body 1')
        plot((1 - mu), 0, 'bo', 'MarkerSize', 8, 'DisplayName', 'Primary Body 2')

        % Plot Lagrange Points
        plot(lagrange_points(1,1), lagrange_points(1,2), 'k*', 'MarkerSize', 10, 'DisplayName', 'L1')
        plot(lagrange_points(2,1), lagrange_points(2,2), 'm*', 'MarkerSize', 10, 'DisplayName', 'L2')
        plot(lagrange_points(3,1), lagrange_points(3,2), 'c*', 'MarkerSize', 10, 'DisplayName', 'L3')
        plot(lagrange_points(4,1), lagrange_points(4,2), 'g*', 'MarkerSize', 10, 'DisplayName', 'L4')
        plot(lagrange_points(5,1), lagrange_points(5,2), 'y*', 'MarkerSize', 10, 'DisplayName', 'L5')

        % Move legend outside the axis
        lgd = legend('Location','northeastoutside');
        lgd.AutoUpdate = 'off';
        % Adjust axes to make space for legend and colorbar
        ax = gca;
        ax.Position = [0.1 0.1 0.65 0.8];  % [left bottom width height]

        % Use automatic paper size to prevent legend from being cut
        set(gcf,'PaperPositionMode','auto');

        % Save figure if requested using exportgraphics for full legend
        if save_image
            filename = fullfile(base_path_im, sprintf('PhaseSpace_C_%.4f_theta_%.2f.png', C, theta));
            exportgraphics(gcf, filename, 'Resolution',300)
        end
    end 

    % ============================ Stable manifolds =========================
    if plt_stb_man
        figure(2)

        h_pcolor = pcolor(X, Y, D_future);
        shading interp
        colorbar
        xlabel('x_0','FontSize',16)
        ylabel('y_0','FontSize',16)
        axis equal tight   
        title(sprintf('Stable Manifolds - C = %.4f, \\theta = %.2f', C, theta), 'FontSize',18)

        hold on

        % Plot primary bodies
        plot(-mu, 0, 'ro', 'MarkerSize', 8, 'DisplayName', 'Primary Body 1')
        plot((1 - mu), 0, 'bo', 'MarkerSize', 8, 'DisplayName', 'Primary Body 2')

        % Plot Lagrange Points
        plot(lagrange_points(1,1), lagrange_points(1,2), 'k*', 'MarkerSize', 10, 'DisplayName', 'L1')
        plot(lagrange_points(2,1), lagrange_points(2,2), 'm*', 'MarkerSize', 10, 'DisplayName', 'L2')
        plot(lagrange_points(3,1), lagrange_points(3,2), 'c*', 'MarkerSize', 10, 'DisplayName', 'L3')
        plot(lagrange_points(4,1), lagrange_points(4,2), 'g*', 'MarkerSize', 10, 'DisplayName', 'L4')
        plot(lagrange_points(5,1), lagrange_points(5,2), 'y*', 'MarkerSize', 10, 'DisplayName', 'L5')

        lgd = legend('Location','northeastoutside');
        lgd.AutoUpdate = 'off';
        ax = gca;
        ax.Position = [0.1 0.1 0.65 0.8];
        set(gcf,'PaperPositionMode','auto');

        if save_image
            filename = fullfile(base_path_im, sprintf('Stb_Man_C_%.4f_theta_%.2f.png', C, theta));
            exportgraphics(gcf, filename, 'Resolution',300)
        end
    end

    % ============================ Unstable manifolds =========================
    if plt_unstb_man
        figure(3)

        h_pcolor = pcolor(X, Y, D_past);
        shading interp
        colorbar
        xlabel('x_0','FontSize',16)
        ylabel('y_0','FontSize',16)
        axis equal tight   
        title(sprintf('Unstable Manifolds - C = %.4f, \\theta = %.2f', C, theta), 'FontSize',18)

        hold on

        % Plot primary bodies
        plot(-mu, 0, 'ro', 'MarkerSize', 8, 'DisplayName', 'Primary Body 1')
        plot((1 - mu), 0, 'bo', 'MarkerSize', 8, 'DisplayName', 'Primary Body 2')

        % Plot Lagrange Points
        plot(lagrange_points(1,1), lagrange_points(1,2), 'k*', 'MarkerSize', 10, 'DisplayName', 'L1')
        plot(lagrange_points(2,1), lagrange_points(2,2), 'm*', 'MarkerSize', 10, 'DisplayName', 'L2')
        plot(lagrange_points(3,1), lagrange_points(3,2), 'c*', 'MarkerSize', 10, 'DisplayName', 'L3')
        plot(lagrange_points(4,1), lagrange_points(4,2), 'g*', 'MarkerSize', 10, 'DisplayName', 'L4')
        plot(lagrange_points(5,1), lagrange_points(5,2), 'y*', 'MarkerSize', 10, 'DisplayName', 'L5')

        lgd = legend('Location','northeastoutside');
        lgd.AutoUpdate = 'off';
        ax = gca;
        ax.Position = [0.1 0.1 0.65 0.8];
        set(gcf,'PaperPositionMode','auto');
        


        if save_image
            filename = fullfile(base_path_im, sprintf('Unstb_Man_C_%.4f_theta_%.2f.png', C, theta));
            exportgraphics(gcf, filename, 'Resolution',300)
        end

    
    end 

end
