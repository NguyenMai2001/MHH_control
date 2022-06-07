function ddq  = fcn(Tau,q,dq)
[m1,m2,m3,L1,L2,L3,I1x,I1y,I1z,I2x,I2y,I2z,I3x,I3y,I3z]=parameter ();

q=zeros(3,1);
dq=zeros(3,1);

% Khai bao ma tran khoi luong M
M=zeros(3,3);
M(1,1)= (9/4)*m1*L1^2+I1z+3*m2*L2*L1*cos(q(2))+L1^2*m2+(9/4)*m2*L2^2+I2y+2*m3*L2*L1*cos(q(2))+3*m3*L1*q(3)*sin(q(2))+L1^2*m3+L2^2*m3+(9/4)*m3*q(3)^2+I3y;
M(1,2)= (3/2)*m2*L2*L1*cos(q(2))+(9/4)*m2*L2^2+I2y+m3*L2*L1*cos(q(2))+(3/2)*m3*L1*q(3)*sin(q(2))+L2^2*m3+(9/4)*m3*q(3)^2+I3y;
M(1,3)= -(3/2)*L1*m3*cos(q(2))-(3/2)*L2*m3;


M(2,1)=(3/2)*m2*L2*L1*cos(q(2))+(9/4)*m2*L2^2+I2y+m3*L2*L1*cos(q(2))+(3/2)*m3*L1*q(3)*sin(q(2))+L2^2*m3+(9/4)*m3*q(3)^2+I3y;
M(2,2)=(9/4)*m2*L2^2+I2y+L2^2*m3+(9/4)*m3*q(3)^2+I3y;
M(2,3)=-(3/2)*L2*m3;

M(3,1)=-(3/2)*L1*m3*cos(q(2))-(3/2)*L2*m3;
M(3,2)=-(3/2)*L2*m3;
M(3,3)=(9/4)*m3;

% Khai bao ma tran Coriolis C
%h=-m2*L1*Lc2*sin(q(2));
Co=zeros(3,3);
Co(1,1)=-3*L1*L2*sin(q(2))*dq(2)*m2-2*L1*L2*sin(q(2))*dq(2)*m3+3*L1*cos(q(2))*dq(2)*m3*q(3)+3*L1*m3*sin(q(2))*dq(3)+(9/2)*m3*q(3)*dq(3);
Co(1,2)=-(3/2)*L1*L2*sin(q(2))*dq(2)*m2-L1*L2*sin(q(2))*dq(2)*m3+(3/2)*L1*cos(q(2))*dq(2)*m3*q(3)+(3/2)*L1*m3*sin(q(2))*dq(3)+(9/2)*m3*q(3)*dq(3);
Co(1,3)=(3/2)*L1*m3*sin(q(2))*dq(2);


Co(2,1)=(3/2)*L1*L2*sin(q(2))*dq(1)*m2+L1*L2*sin(q(2))*dq(1)*m3-(3/4)*L1*L2*sin(q(2))*dq(2)*m2-(1/2)*L1*L2*sin(q(2))*dq(2)*m3-(3/2)*L1*cos(q(2))*dq(1)*m3*q(3)+(3/4)*L1*cos(q(2))*dq(2)*m3*q(3)+(3/4)*L1*m3*sin(q(2))*dq(3)+(9/2)*m3*q(3)*dq(3);
Co(2,2)=(3/4)*L1*L2*sin(q(2))*dq(1)*m2+(1/2)*L1*L2*sin(q(2))*dq(1)*m3-(3/4)*L1*cos(q(2))*dq(1)*m3*q(3)+(9/2)*m3*q(3)*dq(3);
Co(2,3)=-(3/4)*L1*m3*sin(q(2))*dq(1);


Co(3,1)=-(3/2)*L1*m3*sin(q(2))*dq(1)+(3/4)*L1*m3*sin(q(2))*dq(2)-(9/4)*dq(1)*m3*q(3)-(9/4)*m3*q(3)*dq(2);
Co(3,2)=-(3/4)*L1*m3*sin(q(2))*dq(1)-(9/4)*dq(1)*m3*q(3)-(9/4)*m3*q(3)*dq(2);
Co(3,3)=0;

% Ma tran the nang hap dan
G=zeros(3,1);
G(1,1)=15*m1*L1*cos(q(1))+10*m2*L1*cos(q(1))+10*m3*L1*cos(q(1))+15*m2*L2*cos(q(1)+q(2))+10*m3*L2*cos(q(1)+q(2))+15*m3*sin(q(1)+q(2))*q(3);
G(2,1)=15*m2*L2*cos(q(1)+q(2))+10*m3*L2*cos(q(1)+q(2))+15*m3*sin(q(1)+q(2))*q(3);
G(3,1)=-15*m3*cos(q(1)+q(2));


% Pt DLH
ddq=inv(M)*(Tau-Co*dq-G);
