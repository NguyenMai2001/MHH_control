function Jnd=Jacobian(q1,q2,q3)
[L1,L2,L3,R,h]=bien();
%% Jacobian
%J=zeros(3,3);
% xE = sin(q1+q2)*q3+L2*cos(q1+q2)+L1*cos(q1);
% yE = -cos(q1+q2)*q3+L2*sin(q1+q2)+L1*sin(q1);
% zE = 0;
J11 = cos(q1 + q2) * q3 - L2 * sin(q1 + q2) - L1 * sin(q1);
J12 = cos(q1 + q2) * q3 - L2 * sin(q1 + q2);
J13 = sin(q1 + q2);

J21 = sin(q1 + q2) * q3 + L2 * cos(q1 + q2) + L1 * cos(q1);
J22 = sin(q1+q2)*q3+L2*cos(q1+q2);
J23 = -cos(q1 + q2);

J31 = 0;
J32 = 0;
J33 = 0;

J=[J11 J12 J13;J21 J22 J23;J31 J32 J33];

%% Chuyen vi Jacobian
Jt=J';
%% Jacobi tua nghich dao
Jnd = (Jt*pinv(J*Jt));



