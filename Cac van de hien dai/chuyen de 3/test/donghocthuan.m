function [xE,yE]=donghocthuan(q1,q2,q3)
[L1,L2,L3,R]=bien();
xE = sin(q1+q2)*q3+L2*cos(q1+q2)+L1*cos(q1);
yE = -cos(q1+q2)*q3+L2*sin(q1+q2)+L1*sin(q1);
end