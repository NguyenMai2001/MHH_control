%%
clc
clear
close all
% Link length- can be changed
L1 = 2; % length of first arm
L2 = 0.3; % length of second arm
L3 = 0.7; % length of third arm
L4 = 0.7;
L5 = 0.3;
hold('on')
% Axis Properties
%X=[0 0 L2 L2+L3 L2+L3 L2+l3+L4 L2+L3+L4+L5];
X=[0 0 L2 L2+L3 L2+L3 L2+L3+L4 L2+L3+L4];
Y=[0 0 0 0 0 0 0];
Z=[0 L1 L1 L1 L1 L1 L1+L5]; 
Tool = plot3(X,Y,Z,'mo-','LineWidth',4,'XDataSource','X','YDataSource','Y','ZDataSource','Z');
axis([-4 4 -4 4 -4 4]);
set(gca,'DataAspectRatio',[1 1 1])
grid on
hold('on')

for q1 = -135*pi/180:0.5:135*pi/180
for q2 = 0.5:0.5:L1
for q3 = -90*pi/180:0.5:90*pi/18
for q4 = -180*pi/180:0.5:135*pi/180
for q5 = -30*pi/180:0.5:30*pi/180
X0 = 0;
X1 = 0;
X2 = cos(q1) * L2;
X3 = cos(q1) * (L3 * cos(q3) + L2);
X4 = cos(q1) * (L3 * cos(q3) + L2);
X5 = cos(q1) * (L3 * cos(q3) + cos(q3) * L4 + L2);
X6 = -L5 * cos(q5) * cos(q4) * sin(q3) * cos(q1) + L5 * cos(q5) * sin(q4) * sin(q1) - cos(q1) * cos(q3) * L5 * sin(q5) + cos(q1) * L3 * cos(q3) + cos(q1) * cos(q3) * L4 + cos(q1) * L2;
X=[X0 X1 X2 X3 X4 X5 X6];

Y0 = 0;
Y1 = 0;
Y2 = sin(q1) * L2;
Y3 = sin(q1) * (L3 * cos(q3) + L2);
Y4 = sin(q1) * (L3 * cos(q3) + L2);
Y5 = sin(q1) * (L3 * cos(q3) + cos(q3) * L4 + L2);
Y6 = -L5 * cos(q5) * cos(q4) * sin(q3) * sin(q1) - L5 * cos(q5) * sin(q4) * cos(q1) - sin(q1) * cos(q3) * L5 * sin(q5) + sin(q1) * L3 * cos(q3) + sin(q1) * cos(q3) * L4 + sin(q1) * L2;
Y=[Y0 Y1 Y2 Y3 Y4 Y5 Y6];

Z0 = 0;
Z1 = q2;
Z2 = q2;
Z3 = L3 * sin(q3) + q2;
Z4 = L3 * sin(q3) + q2;
Z5 = sin(q3) * L4 + L3 * sin(q3) + q2;
Z6 = cos(q3) * cos(q4) * L5 * cos(q5) - sin(q3) * L5 * sin(q5) + sin(q3) * L4 + L3 * sin(q3) + q2;
Z=[Z0 Z1 Z2 Z3 Z4 Z5 Z6];

X1 = [0 -L5 * cos(q5) * cos(q4) * sin(q3) * cos(q1) + L5 * cos(q5) * sin(q4) * sin(q1) - cos(q1) * cos(q3) * L5 * sin(q5) + cos(q1) * L3 * cos(q3) + cos(q1) * cos(q3) * L4 + cos(q1) * L2];
Y1 = [0 -L5 * cos(q5) * cos(q4) * sin(q3) * sin(q1) - L5 * cos(q5) * sin(q4) * cos(q1) - sin(q1) * cos(q3) * L5 * sin(q5) + sin(q1) * L3 * cos(q3) + sin(q1) * cos(q3) * L4 + sin(q1) * L2];
Z1 = [0 cos(q3) * cos(q4) * L5 * cos(q5) - sin(q3) * L5 * sin(q5) + sin(q3) * L4 + L3 * sin(q3) + q2];

plot3(X1,Y1,Z1,'b.')
refreshdata(Tool,'caller')
drawnow
grid on
hold on
end
end
end
end
end
         