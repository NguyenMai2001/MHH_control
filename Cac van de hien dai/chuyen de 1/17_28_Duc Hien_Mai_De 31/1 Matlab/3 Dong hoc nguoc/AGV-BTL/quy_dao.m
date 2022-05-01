function [Xd,dXd]=quy_dao(t)
[~,~,~,~,~,R,h]=bien();
Xd(1)=0.9+R*sin(t); %m
Xd(2)=h*t; %m
Xd(3)=0.75+R*cos(t); %m

dXd(1)=R*cos(t);
dXd(2)=h;
dXd(3)=-R*sin(t);
end