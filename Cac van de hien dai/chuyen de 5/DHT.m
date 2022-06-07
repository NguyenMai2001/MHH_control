function [xE,yE,zE] = DHT(q1,q2,q3)

[m1,m2,m3,L1,L2,L3,I1x,I1y,I1z,I2x,I2y,I2z,I3x,I3y,I3z]=parameter ();

xE=sin(q1 + q2) * q3 + L2 * cos(q1 + q2) + L1 * cos(q1);
yE=-cos(q1 + q2) * q3 + L2 * sin(q1 + q2) + L1 * sin(q1);
zE=0;