clc;
close all;
clear;

G = tf([1 2 1 ],[1 2 2 1 0])
erp = 0.005
kvel_d = 1/erp
PM_d = 60
BW_d = 20

zetta = (1/2)*sqrt(tand(PM_d)*sind(PM_d))
wg_d = BW_d*sqrt(sqrt(1+4*zetta^4)-2*zetta^2)/sqrt((1-2*zetta^2)+sqrt(4*zetta^4-4*zetta^2+2))
figure;hold on;
%aph
margin(G)
[mag,pha] = bode(G,wg_d)
kdes = 1/mag;

margin(kdes*G)
marge = 5
[GM,PM,null1,null2]=margin(kdes*G)
d_phi = PM_d -PM + 5

alpha = (1-sind(d_phi))/(1+sind(d_phi))
T =1/(wg_d*sqrt(alpha))
za = -1/T
pa = -1/(alpha*T)
Ka = kdes/sqrt(alpha)
Ga = tf([1 -za],[1 -pa])*Ka

margin(Ga*G)
GaG = Ga*G

%rph
K = kvel_d/(GaG.Numerator{1,1}(end)/GaG.Denominator{1,1}(end-1))

beta = abs(evalfr(K*GaG,i*wg_d))
F = 10
zr = -wg_d/F
T2 = F/wg_d
pr = -1/(beta*T2)
Gr = tf([1 -zr],[1 -pr])
Kr = K/(beta*abs(evalfr(Gr,i*wg_d)))
Gr = Gr*Kr
margin(GaG*Gr)

%verif
GaGrG = GaG*Gr;
BW = bandwidth(feedback(GaGrG,1))
t = [0:0.1:15];
u = t';

y = lsim(feedback(GaGrG,1),u,t);
err = u-y;
figure;
plot(t,err)
erp = err(end)




