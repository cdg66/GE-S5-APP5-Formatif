clc;
close all;
clear;

G1 = tf([1],[1 0]);
G2 = tf([1],[1 8]);
G3 = tf([1],[1 30]);

G = G1*G2*G3*1075

%perf originale
Kvel = 1075/240
erp = 1/Kvel
Kveld = 1/erp

%perf requise
erp_d = 0.5
Kacc_d = 1/erp_d

figure;hold on
rlocus(G,'r')
p = rlocus(G,1)
plot(real(p),imag(p),'s')

wn = abs(p(2))
phi = 180 - rad2deg(angle(p(2)))
zetta = - real(p(2))/wn

PM_d = atand((2*zetta)/sqrt(sqrt(1+4*zetta^4)-2*zetta^2))
wg_d = wn*sqrt(sqrt(1+4*zetta^4)-2*zetta^2)

zetta2 = sqrt(tand(PM_d)*sind(PM_d))/2
F = 7;

figure;
margin(G)

%PI rlocus
Ki = Kacc_d/ Kvel
z = real(p(2))/F
Kpi = -Ki/z
PI = tf([Kpi Ki],[1 0])
Kpi = 1/abs(evalfr(PI*G,p(2)))
figure;hold on
rlocus(G,'r')
plot(real(p),imag(p),'s')
rlocus(G*Kpi*PI,'b')
p2 = rlocus(G*Kpi*PI,1)
plot(real(p2),imag(p2),'p')
GPI = G*Kpi*PI
Kaccc = GPI.Numerator{1,1}(end)/GPI.Denominator{1,1}(end-2)
erp2 = 1/Kaccc

t = [0:0.01:15];
u = (t'.^2)./2;
y = lsim(feedback(GPI,1),u,t);
e = u-y;
figure;
plot(t,e);


% PI bode

z = wg_d/F;
Kpi = -Ki/z 
