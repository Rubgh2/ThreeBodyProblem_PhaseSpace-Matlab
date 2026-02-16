function  [base_path,base_path_data,base_path_im]=Generate_experiment(dx,dy,x_range,y_range, mu,save_path)
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INPUT:
    %       dx - number of points in x.
    %       dy - number of points in y.
    %       x_range - X interval in grid.
    %       y_range - Y interval in grid.
    %       mu - mass parameter.
    %       C  - Jacobi constant. 
    %       theta - vector with values of theta to simulate.
    %       save_path - path to save the folder.
    %
    %   Outputs:
    %     base_path       - Full path to the main experiment folder
    %     base_path_data  - Full path to the 'Data' subfolder (for .csv files)
    %     base_path_im    - Full path to the 'Images' subfolder (for .png plots)
    %
    %   Notes:
    %     - Folder name format: Exp_xspX_yspY_dxD_dyE_muM
    %       (x_span = x_max - x_min, y_span = y_max - y_min)
    %     - Safe to call multiple times: skips creation if folder exists.
    %     - Used to organize results per parameter combination.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Creates Experiment folder name and paths
    x_span = x_range(2) - x_range(1);
    y_span = y_range(2) - y_range(1);
    base_name = sprintf("Exp_xsp%d_ysp%d_dx%d_dy%d_mu%d", x_span, y_span, dx, dy, mu);
    base_path = fullfile(save_path, base_name);
    base_path_im = fullfile(base_path, "Images");
    base_path_data = fullfile(base_path, "Data");
    
    %Create Experiment folder
    if ~exist(base_path,"dir");
        fprintf('Creating new folder for experiment...\n');
        mkdir(base_path);
        
        
        %Create Images subfolder
        mkdir(base_path_im);

        %create Data sufolder
        mkdir(base_path_data);
    end 
    
    
end