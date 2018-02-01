% Framework developed for simulating multi-agent systems
function [MAS] = RunMAS(n,ros,gazebo,AerialIDs,GroundIDs)

%% Basic setup
close all

% Input arguments
if nargin == 0
    error('Not enough input arguments');
elseif nargin == 1
    fprintf('ROS and Gazebo flag not selected, running in MATLAB.\n\n\n')
    ros = false;
    gazebo = false;
    AerialIDs = [];
    GroundIDs = [];
elseif nargin == 2
    fprintf('Gazebo flag not selected, running without it.\n\n\n')
    gazebo = false;
    if ros && isempty(AerialIDs) && isempty(GroundIDs)
        error('Can not run in ROS without any agents!\n\n\n');
    end
    AerialIDs = [];
    GroundIDs = [];
elseif nargin == 3
    fprintf('Running using ROS and Gazebo.\n\n\n');
    if lenght(AerialIDs)+length(GroundIDs)>0
        fprintf('Warning: using Gazebo and real agents.\n\n\n');
    end
elseif nargin == 4
    fprintf('Using only Crazyflies.')
    if ~ros
        error('If you want to use CF, you need to select ROS flag');
    end
    if length(AerialIDs)~=n
        error('Number of agents and CFs do not match');
    end
    GroundIDs = [];
elseif nargin == 5
    if length(AerialIDs)+length(GroundIDs)~=n
        error('Number of agents n and actual agents do not match.\n\n\n');
    end
elseif nargin > 5
    error('Too many input arguments.\n\n\n');
end

%% Fundamental Parameters
Parameters.n = n;                               % Number of agents
Parameters.d = 2;                               % Dimension of the simulation [It can be either 2 or 3]
Parameters.kin = 2;                             % Kinematics [0: Single Integrator; 1: Unicycle; 2: Quadrotor]
Parameters.s = 0;                               % Angular Dimension [It can be either 0, 1, 2 or 3]
Parameters.dt = 1/100;                          % Sampling time [s]
Parameters.t = 5;                              % Simulation time [s]
Parameters.l = 5;                               % Environment One Dimension Size
Parameters.rho = 20;                            % Agent's Visibility
Parameters.rho0 = 0.5;                          % Agent's Visibility
Parameters.ROS = ros;                           % ROS Interaction
Parameters.GAZEBO = gazebo;                     % Gazebo
Parameters.Aerial_HW = 'CF';                    % Select between 'CF' and 'DJI'
Parameters.AerialIDs = AerialIDs;                     % Aerial Agents ID
Parameters.Ground_HW = 'Saetta';                % Only 'Saetta' available now
Parameters.GroundIDs = GroundIDs;                     % Ground Agents ID
Parameters.robot_name = 'ardrone';              % Robot model in Gazebo

%% Functionalities data
Parameters.opt = false;
Parameters.LyapunovAnalysis = false;
Parameters.LyapunovGradientAnalysis = false;
Parameters.HessianAnalysis = false;

%% Simulation data
if ros
    if gazebo
        alpha = 3.0;
    else
        alpha = 1.7;
    end
else
    alpha = 1;
end
if (ros && ~gazebo)
    Parameters.a = alpha*0.6;
    Parameters.b = alpha*1;
else
    Parameters.a = alpha*0.2;
    Parameters.b = alpha*0.2;
end

%% Init Matlab for ROS
% Ros Hostname
% To get your hostname run 'hostname' on terminal/cmd
Parameters.ROS_HOSTNAME = 'DESKTOP-VMP0EHV';         % Hostname
Parameters.ROS_IP = '192.168.11.1';                  % Hostname address
% Parameters.ROS_HOSTNAME = 'Andreas-MBP';

% ROS Master Node
% a. Detect the ip of the virtual machine (ifconfig eth0 from terminal)
% b. Add the following line at the end of the file etc/hosts
%    192.168.127.XXX	ROS-INDIGO
%
%    I.     Linux/Mac:  /etc/hosts
%    II.    Windows:    C:\Windows\System32\drivers\etc\hosts
% Both machine should now be able to ping each other
Parameters.ROS_MASTER_URI = 'http://192.168.11.2:11311';          % Virtual Machine Address

%% MAF Data Structure Setting
MAS = initFramework(Parameters);

%% Cleanup Function as Callback [for ctrl+c]
finishup = onCleanup(@() myCleanupFun(MAS));

%% Initialize Graphics
MAS = initGraphics(MAS);

%% Perfor Simulation
MAS = simMAS(MAS);

%% Clean Graphics [Not Implemented Yet]
cleanGraphics(MAS);

%% Show Speed
plotAgentsSpeed(MAS);

%% Show Distance
plotAgentsDistance(MAS);

% %% Show Lyapunov Evolution
% plotAgentsLyapunov(MAS);

%% Cleanup The Environment
myCleanupFun(MAS);

end
