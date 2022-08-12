function Jnd=TinhJnd(q1,q2,q3)
[d1,a2,a3,R,h]=parameter();
%% Jacobian
%J=zeros(3,3);
J11=-sin(q1) * (cos(q3) * cos(q2) * a3 - sin(q3) * sin(q2) * a3 + a2 * cos(q2));
J12=-cos(q1) * (sin(q2) * a3 * cos(q3) + cos(q2) * a3 * sin(q3) + a2 * sin(q2));
J13=-cos(q1) * a3 * (sin(q2) * cos(q3) + cos(q2) * sin(q3));

J21=cos(q1) * (cos(q3) * cos(q2) * a3 - sin(q3) * sin(q2) * a3 + a2 * cos(q2));
J22=-sin(q1) * (sin(q2) * a3 * cos(q3) + cos(q2) * a3 * sin(q3) + a2 * sin(q2));
J23=-sin(q1) * a3 * (sin(q2) * cos(q3) + cos(q2) * sin(q3));

J31=0;
J32= cos(q3) * cos(q2) * a3 - sin(q3) * sin(q2) * a3 + a2 * cos(q2);
J33=a3 * (cos(q2) * cos(q3) - sin(q2) * sin(q3));

J=[J11 J12 J13;J21 J22 J23;J31 J32 J33];

%% Chuyen vi Jacobian
Jt=J';
%% Jacobi tua nghich dao
Jnd = (Jt*inv(J*Jt));


