close all; clear; clc;

kr = 100;
Im = 0.01;
Fm = 0.01;
Ra = 10;
kt = 2;
kv = 2;
KP = 5;
KV = 10;
kTP = 1;
kTV = 1;

km = 1/kv;
Tm = (Ra*Im)/(kt*kv);
TV = Tm;
TP = 100*Tm;

Xr = KP*KV*kTP;
fprintf('He so loai bo nhieu: %f\n', Xr);
wn = sqrt(Xr*km);
psi = (KV*kTP*km)/(2*wn);
fprintf('Tan so tu nhien %f va he so can %f\n', wn, psi);
Tr = max(1/(psi*wn), Tm);
fprintf('Thoi gian phuc hoi loi ra: %f\n', Tr);
