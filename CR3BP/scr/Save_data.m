function []=Save_data(D,D_past,D_future,C,theta,base_path_data)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  Saves the result of LDs method in .csv
        %       
        %  INPUT: 
        %        C - Jacobi constant
        %        theta - speed direction  
        %        base_path_dath - path where we want to save data
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Files names
        name_M_funct_all = fullfile(base_path_data, sprintf('M_funct_C_%.4f_theta_%.2f.csv',C, theta));
        name_M_funct_past = fullfile(base_path_data, sprintf('M_funct_past_C_%.4f_theta_%.2f.csv',C, theta));
        name_M_funct_future = fullfile(base_path_data, sprintf('M_funct_future_C_%.4f_theta_%.2f.csv',C, theta));
        
        %Save files
        writematrix(D,name_M_funct_all);
        writematrix(D_past,name_M_funct_past);
        writematrix(D_future,name_M_funct_future);
end