function [MAS] = initFramework(Parameters)

%% Simulation Variables
MAS.n = Parameters.n;                            % Number of Agents
MAS.d = Parameters.d;                            % Euclidean Space Dimension
MAS.s = Parameters.s;                            % Angular
MAS.kin = Parameters.kin;                        % Agent's Kinematic [0: single integrator; 1: unicycle; 2: quadrotor]
MAS.dt = Parameters.dt;                          % Sampling Time
MAS.t = Parameters.t;                            % Total Time
MAS.ct = 0;                                      % Current Time
MAS.l = Parameters.l;                            % Environment Size
MAS.rho = Parameters.rho;                        % Visibility
MAS.rho0 = Parameters.rho0;                      % Agents' repulsion interaction radius
MAS.iter = 0;
MAS.eta = 0;                                     % Physical Occupancy [Not Implemented Yet]
MAS.robot_name = Parameters.robot_name;          % Drone type
MAS.ROS_MASTER_URI = Parameters.ROS_MASTER_URI;
MAS.ROS_HOSTNAME = Parameters.ROS_HOSTNAME;
MAS.ROS_IP = Parameters.ROS_IP;
MAS.ROS = Parameters.ROS;
MAS.GAZEBO = Parameters.GAZEBO;
MAS.Aerial_HW = Parameters.Aerial_HW;
MAS.RobCFs = Parameters.RobCFs;
MAS.Ground_HW = Parameters.Ground_HW;
MAS.RobSAs = Parameters.RobSAs;
MAS.opt = Parameters.opt;
MAS.LyapunovAnalysis = Parameters.LyapunovAnalysis;
MAS.LyapunovGradientAnalysis = Parameters.LyapunovGradientAnalysis;
MAS.HessianAnalysis = Parameters.HessianAnalysis;
MAS.a = Parameters.a;
MAS.b = Parameters.b;

MAS.poseHist = [];
MAS.speedHist = [];
MAS.graphHist = [];


%% Graphics Variables
% Visibility
if (MAS.ROS)
    MAS.showGraphics =  false;
else
    MAS.showGraphics =  true;
end

MAS.showAgents =  true;
MAS.showSpeed = true;
MAS.showLinks =  false;
MAS.showRadius =  false;
MAS.centerOfGravity = false;
MAS.showIDs = true;
MAS.offset_text = 0.05;

% Grahics Properties
if MAS.d == 2
    MAS.plotRange = [-MAS.l MAS.l -MAS.l MAS.l];
else
    MAS.plotRange = [-MAS.l MAS.l -MAS.l MAS.l -MAS.l MAS.l];
end
MAS.markerAgents='o';
MAS.colorAgents='r';
MAS.lineStyleEdges = '-';
MAS.lineWidthEdges = '.5';
MAS.colorEdges = 'b';
MAS.lineStyleRadius = '--';
MAS.widthRadius = '.5';
MAS.colorRadius = 'k';


%% ROS Data Structure
if (MAS.ROS)
    MAS = initROS(MAS);
else
    MAS = initMATLAB(MAS);
end

end