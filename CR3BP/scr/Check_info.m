function [ph_data_file,unstb_man_data_file,stb_man_data_file,...
          need_plt_ph_space,need_plt_stb_man,need_plt_unstb_man,...
          ph_data_exists,stb_man_data_exists, unstb_man_data_exists,...
          ph_space_image_exists,stb_man_image_exists,unstb_man_image_exists,...
          need_ph_data,need_stb_man_data,need_unstb_man_data]=...
          Check_info(C,theta,plt_phase_space,plt_stb_man,plt_unstb_man,base_path_data,base_path_im)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHECK_INFO  
        %   Check existence of data files and images for a given (C, theta) pair. 
        %   It determines which computations and plots are still needed, 
        %   allowing the main script to skip redundant work.
        %
        %   Inputs:
        %     C                  - Jacobi constant 
        %     theta              - Direction 
        %     plt_phase_space    - Boolean: true if user wants to plot full phase space
        %     plt_stb_man        - Boolean: true if user wants to plot stable manifold
        %     plt_unstb_man      - Boolean: true if user wants to plot unstable manifold
        %     base_path_data     - Base folder path for saving/loading .csv data files
        %     base_path_im       - Base folder path for saving/loading .png image files
        %
        %   Outputs:
        %     ph_data_file             - Full path to the main M-function .csv file
        %     unstb_man_data_file      - Full path to past (unstable) M-function .csv
        %     stb_man_data_file        - Full path to future (stable) M-function .csv
        %     need_plt_ph_space        - true if phase space plot needs to be generated
        %     need_plt_stb_man         - true if stable manifold plot needs to be generated
        %     need_plt_unstb_man       - true if unstable manifold plot needs to be generated
        %     ph_data_exists           - true if main data file already exists
        %     stb_man_data_exists      - true if stable (future) data file exists
        %     unstb_man_data_exists    - true if unstable (past) data file exists
        %     ph_space_image_exists    - true if phase space image already exists
        %     stb_man_image_exists     - true if stable manifold image exists
        %     unstb_man_image_exists   - true if unstable manifold image exists
        %     need_ph_data             - true if main data needs to be computed
        %     need_stb_man_data        - true if stable data needs to be computed
        %     need_unstb_man_data      - true if unstable data needs to be computed 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %File names
        ph_data_file = fullfile(base_path_data, ...
            sprintf('M_funct_C_%.4f_theta_%.2f.csv', C, theta));
        stb_man_data_file = fullfile(base_path_data, ...
            sprintf('M_funct_future_C_%.4f_theta_%.2f.csv', C, theta));
        unstb_man_data_file = fullfile(base_path_data, ...
            sprintf('M_funct_past_C_%.4f_theta_%.2f.csv', C, theta));

        ph_space_file = fullfile(base_path_im, ...
            sprintf('PhaseSpace_C_%.4f_theta_%.2f.png', C, theta));
        
        stb_man_file = fullfile(base_path_im, ...
            sprintf('Stb_Man_C_%.4f_theta_%.2f.png', C, theta));
        
        unstb_man_file = fullfile(base_path_im, ...
            sprintf('Unstb_Man_C_%.4f_theta_%.2f.png', C, theta));
        
        % Verifies which files exist
        ph_data_exists = exist(ph_data_file,'file');
        stb_man_data_exists=exist(stb_man_data_file,'file');
        unstb_man_data_exists=exist(unstb_man_data_file,'file');
        
        ph_space_image_exists = exist(ph_space_file,'file');
        stb_man_image_exists = exist(stb_man_file,'file');
        unstb_man_image_exists = exist(unstb_man_file,'file');

        % Decide what to do 
        need_ph_data = ~ph_data_exists;
        need_stb_man_data=~stb_man_data_exists;
        need_unstb_man_data=~unstb_man_data_exists;

        need_plt_ph_space = plt_phase_space && ~ph_space_image_exists;
        need_plt_stb_man = plt_stb_man && ~stb_man_image_exists;
        need_plt_unstb_man = plt_unstb_man && ~unstb_man_image_exists;




end 