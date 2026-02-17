clear all
close all
clc
tic
%% Setup paths
addpath(fullfile(pwd, 'scr'));
results_path = fullfile(pwd, 'results');

%%%%%%%%%%%%%%%%%% INTEGRATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%

N = 2;              % We recommend:
                    %        - N=2 for plotting the phase space, 
                    %          (un)stable manifolds (ODE113) chooses
                    %          optimal number of points.
                    %
                    %        - N \in [200,1000] if you want to plot a 
                    %          trajectory.               
     
t0 = 0;
tf = 4*pi;          % 4*pi is the minimum recommended.

tspan=zeros(N,2);
tspan(:,1)=linspace(t0, tf, N);
tspan(:,2)=linspace(t0, -tf, N);

%%%%%%%%%%%%%%%%%%%% GRID PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%

%RANGE$
x0 = [-1.5, 1.5];
y0 = [-1.5, 1.5];

%POINTS IN GRID%
dx = 200;               
dy = 200;


init_condx = linspace(x0(1), x0(2), dx);
init_condy = linspace(y0(1), y0(2), dy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% MASS PARAMETER %%%%%%%%%%%%%%%%%%%%%

m1 = 5.972e24;              % The Earth's mass           
m2 = 7.348e22;              % Moons' mass         
mu = m2 / (m1 + m2);        % Mass parameter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%% DIRECTION AND ENERGY  %%%%%%%%%%%%%%%%%%%%%%%%%%% 


%%%ANGLES%%%
thetas=[0.0];       % Vector with the initial directions you want to integrate.  

%%%ENERGIES%%%

%Choose the indices of the energies in C_values vector (len=9)
% you want to chose. For example energy_idx=1, energy_idx=3:7.
% energy_idx=2,4,6,8 correspond to L1,L2,L3 and L4-L5 respectively; the
% rest are intermediate points. energy_idx=1 lower C than in L1. 

energy_idx=8;     %Energy of L4-L5

%If you want personalized energies, set energy_idx =[], and
%put values in the following commented list:

% C_values=[Energies you want to study];


%Choose the grid position corresponding to the initial position
% of the trajectories you want to plot 


traj_pos=[131,57;
          66,100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% PLOTTING AND SAVING OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% DATA %%%
save_data = true;
plt_phase_space = true;
plt_stb_man=true;
plt_unstb_man=true;

%%% IMAGES %%%
save_image=true;

%%% TRAJECTORIES %%%
plt_trajectories =true;
save_trajectory =true;



%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate folders and grid
[base_path, base_path_data, base_path_im] = ...
    Generate_experiment(dx,dy,x0,y0,mu,results_path);

[X, Y] = Generate_grid(x0,y0,dx,dy,base_path);

% Calculate Lagrange points 
lagrange_points = Lagrange_Points(mu);

%If we use energies related to Lagrange points:
if ~isempty(energy_idx)
    C_val = Lagrange_Energy(mu, lagrange_points);
    C_values=C_val(energy_idx);
end

% ================= MAIN LOOP =================
for c_idx = 1:length(C_values)
    for theta_idx = 1:length(thetas)
        
        theta = thetas(theta_idx);
        C = C_values(c_idx);
        D=[];
        
        %Check what we have already calculated/plotted and 
        % what do we need
        [ph_data_file,unstb_man_data_file,stb_man_data_file,...
        need_plt_ph_space,need_plt_stb_man,need_plt_unstb_man,...
        ph_data_exists,stb_man_data_exists, unstb_man_data_exists,...
        ph_space_image_exists,stb_man_image_exists,unstb_man_image_exists,...
        need_ph_data,need_stb_man_data,need_unstb_man_data]=...
        Check_info(C,theta,plt_phase_space,plt_stb_man,plt_unstb_man,...
        base_path_data,base_path_im);
     
     
        % ==================================================
        %                DATA MANAGEMENT
        % ==================================================
        
        need_any_data = ...
            need_ph_data || ...
            need_stb_man_data || ...
            need_unstb_man_data;
        
        if need_any_data
            
            fprintf('Computing C = %g, theta = %.4f\n', C, theta);
        
            [D, D_past, D_future] = ...
                LDs(dx, dy, tspan, init_condx, init_condy, mu, C, theta);
        
            if save_data
                Save_data(D, D_past, D_future, C, theta, base_path_data);
            end
        
        else
            % Load only what we are actually going to use
            
            if (need_plt_ph_space|| plt_trajectories)
                D = load(ph_data_file);
            end
            
            if need_plt_unstb_man
                D_past = load(unstb_man_data_file);
            end
            
            if need_plt_stb_man
                D_future = load(stb_man_data_file);
            end
        end


        % ---- Plot ----
        % Phase Spaces
        if need_plt_ph_space || need_plt_stb_man || need_plt_unstb_man
    
            Plot_phase_space( ...
                X, Y, C, theta, ...
                D, D_past, D_future, ...
                mu, lagrange_points, ...
                need_plt_ph_space, ...
                need_plt_stb_man, ...
                need_plt_unstb_man, ...
                save_image, base_path_im);
        
        end
        
        % Trajectories

        if plt_trajectories
            if isempty(D)
                D=load(ph_data_file);
            end
            Calculate_Plot_trajectories(init_condx, init_condy, mu, C, theta, tspan, traj_pos, ...
            base_path_data, base_path_im, ...
            plt_trajectories, save_image, ...
            X, Y, lagrange_points);
        end
    end
end

toc