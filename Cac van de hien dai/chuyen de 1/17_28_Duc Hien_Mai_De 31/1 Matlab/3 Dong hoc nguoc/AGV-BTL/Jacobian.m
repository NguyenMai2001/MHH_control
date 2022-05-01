function Jnd=Jacobian(q1,q2,q3,q4,q5)
[L1,L2,L3,L4,L5,R,h]=bien();
%% Jacobian
%J=zeros(3,3);

J11 = L5*cos(q5)*cos(q4)*sin(q3)*sin(q1)+L5*cos(q5)*sin(q4)*cos(q1)+sin(q1)*cos(q3)*L5*sin(q5)-sin(q1)*L3*cos(q3)-sin(q1)*cos(q3)*L4-sin(q1)*L2;
J12 = 0;
J13 = -L5*cos(q5)*cos(q4)*cos(q3)*cos(q1)+cos(q1)*sin(q3)*L5*sin(q5)-cos(q1)*L3*sin(q3)-cos(q1)*sin(q3)*L4;
J14 = L5*cos(q5)*sin(q4)*sin(q3)*cos(q1)+L5*cos(q5)*cos(q4)*sin(q1);
J15 = L5*sin(q5)*cos(q4)*sin(q3)*cos(q1)-L5*sin(q5)*sin(q4)*sin(q1)-cos(q1)*cos(q3)*L5*cos(q5);

J21 = -L5*cos(q5)*cos(q4)*sin(q3)*cos(q1)+L5*cos(q5)*sin(q4)*sin(q1)-cos(q1)*cos(q3)*L5*sin(q5)+cos(q1)*L3*cos(q3)+cos(q1)*cos(q3)*L4+cos(q1)*L2;
J22 = 0;
J23 = -L5*cos(q5)*cos(q4)*cos(q3)*sin(q1)+sin(q1)*sin(q3)*L5*sin(q5)-sin(q1)*L3*sin(q3)-sin(q1)*sin(q3)*L4;
J24 = L5*cos(q5)*sin(q4)*sin(q3)*sin(q1)-L5*cos(q5)*cos(q4)*cos(q1);
J25 = L5*sin(q5)*cos(q4)*sin(q3)*sin(q1)+L5*sin(q5)*sin(q4)*cos(q1)-sin(q1)*cos(q3)*L5*cos(q5);

J31 = 0;
J32 = 1;
J33 = -L5*cos(q5)*cos(q4)*sin(q3)-L5*cos(q3)*sin(q5)+L4*cos(q3)+L3*cos(q3);
J34 = -L5*cos(q5)*sin(q4)*cos(q3);
J35 = -L5*sin(q5)*cos(q4)*cos(q3)-L5*sin(q3)*cos(q5);

J=[J11 J12 J13 J14 J15;J21 J22 J23 J24 J25;J31 J32 J33 J34 J35];

%% Chuyen vi Jacobian
Jt=J';
%% Jacobi tua nghich dao
Jnd = (Jt*inv(J*Jt));



