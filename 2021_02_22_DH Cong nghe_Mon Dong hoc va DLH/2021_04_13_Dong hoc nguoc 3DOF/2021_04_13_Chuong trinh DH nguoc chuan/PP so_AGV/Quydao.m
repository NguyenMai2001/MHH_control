function [Xd,dXd]=Quydao(t)
[d1,a2,a3,R,h]=parameter();
Xd(1)=0.5+R*sin(t); %m
Xd(2)=h*t; %m
Xd(3)=0.35+R*cos(t); %m

dXd(1)=R*cos(t);
dXd(2)=h;
dXd(3)=-R*sin(t);
end
