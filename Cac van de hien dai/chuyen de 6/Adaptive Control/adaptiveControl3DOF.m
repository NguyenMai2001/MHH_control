% Adaptive control "Desired Compensation Adaption Law (DCAL)" 
%                  "Inertial Related Controller (IRC)"

clear 

[m1,m2,m3,L1,L2,L3,I1x,I1y,I1z,I2x,I2y,I2z,I3x,I3y,I3z,g]=parameter ();

%% sampling 0.02s
kp1 = 0.05;
kp2 = 1;
kp3 = 1;

kv1 = 0.2;
kv2 = 0.2;
kv3 = 0.2;

ka = 0.1;

gam1 = 1;
gam2 = 1;
gam3 = 1;

tf = 3;
ts = 0;
tick = 0.02;
t = 0;


%{
%% sampling 0.002s
kp = 100;
kv = 3;   % cannot be higher than 3
ka = 20;

gam1 = 20;
gam2 = 20;

tf = 3;
ts = 0;
tick = 0.002;
t = 0;
%}
%%



