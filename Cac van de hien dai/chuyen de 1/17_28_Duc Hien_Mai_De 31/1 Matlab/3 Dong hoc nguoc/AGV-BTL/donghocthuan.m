function [xE,yE,zE]=donghocthuan(q1,q2,q3,q4,q5)
[L1,L2,L3,L4,L5,R,h]=bien();
xE = -L5 * cos(q5) * cos(q4) * sin(q3) * cos(q1) + L5 * cos(q5) * sin(q4) * sin(q1) - cos(q1) * cos(q3) * L5 * sin(q5) + cos(q1) * L3 * cos(q3) + cos(q1) * cos(q3) * L4 + cos(q1) * L2;
yE = -L5 * cos(q5) * cos(q4) * sin(q3) * sin(q1) - L5 * cos(q5) * sin(q4) * cos(q1) - sin(q1) * cos(q3) * L5 * sin(q5) + sin(q1) * L3 * cos(q3) + sin(q1) * cos(q3) * L4 + sin(q1) * L2;
zE = cos(q3) * cos(q4) * L5 * cos(q5) - sin(q3) * L5 * sin(q5) + sin(q3) * L4 + L3 * sin(q3) + q2;
end