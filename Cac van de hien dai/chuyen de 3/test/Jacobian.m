function Jnd=Jacobian(q1,q2,q3)
[L1,L2,L3,R]=bien();
%% Jacobian
%J=zeros(3,3);

J11 = cos(q1+q2)*q3-L2*sin(q1+q2)-L1*sin(q1);
J12 = sin(q1+q2)*q3+L2*cos(q1+q2)+L1*cos(q1);

J21 = cos(q1+q2)*q3-L2*sin(q1+q2);
J22 = sin(q1+q2)*q3+L2*cos(q1+q2);

J31 = sin(q1+q2);
J32 = -cos(q1+q2);

J=[J11 J12;J21 J22;J31 J32];

%% Chuyen vi Jacobian
Jt=J';
%% Jacobi tua nghich dao
Jnd = (Jt*inv(J*Jt));



