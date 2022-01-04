close all; clear; clc;

kr = 100;
Im = 0.01;
Fm = 0.01;
Ra = 10;
kt = 2;
kv = 2;
KP = 5;
kTP = 1;

km = 1/kv;
Tm = (Ra*Im)/(kt*kv);
TP = 100*Tm;

Xr = KP*kTP;
fprintf('He so loai bo nhieu: %f\n', Xr);
wn = sqrt(Xr*km*TP/Tm);
psi = (wn^2/(Xr*km) - 1)/(2*TP*wn);
fprintf('Tan so tu nhien %f va he so can %f\n', wn, psi);
Tr = max(1/(psi*wn), TP);
fprintf('Thoi gian phuc hoi loi ra: %f\n', Tr);
