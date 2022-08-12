function [xE,yE,zE]=Donghocthuan(q1,q2,q3)
[d1,a2,a3,R,h]=parameter();
xE=cos(q1)*(a2*cos(q2)+a3*cos(q2+q3));
yE=sin(q1)*(a2*cos(q2)+a3*cos(q2+q3));
zE=d1+a2*sin(q2)+a3*sin(q2+q3);
end