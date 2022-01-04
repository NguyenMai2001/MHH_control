close all; clear; clc;

kr = 100;
Im = 0.01;
Fm = 0.01;
Ra = 10;
kt = 2;
kv = 2;
KP = 26;
KV = 12;
KA = 1.5;
kTP = 1;
kTV = 1;
kTA = 1;

km = 1/kv;
Tm = (Ra*Im)/(kt*kv);
TV = Tm;
TA = Tm;
TP = 100*Tm;

Xr = KA*KP*KV*kTP;
fprintf('He so loai bo nhieu: %f\n', Xr);
wn = sqrt((km*Xr)/(km*KA*kTA + 1));
psi = (wn*kTV)/(2*KP*kTP);
fprintf('Tan so tu nhien %f va he so can %f\n', wn, psi);
Tr = max(1/(psi*wn), TA);
fprintf('Thoi gian phuc hoi loi ra: %f\n', Tr);
