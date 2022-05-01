function [Xd,dXd]=quy_dao(t)
[~,~,~,~,~,R]=bien();
Xd(1)=0.3+R*sin(t); %m
Xd(2)=0.75+R*cos(t); %m%m

dXd(1)=R*cos(t);
dXd(2)=-R*sin(t);
end