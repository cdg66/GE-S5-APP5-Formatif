clc;
close all;
clear all;

G = tf([1 2 1], [1 2 2 1 0])

erp = 0.005;
PM_d = 80;

Kvel_d = 1/erp
Kvel = 1/1
K_d = Kvel_d/Kvel

%aph
figure; hold on;
margin(G)
margin(K_d*G)
[GM,PM,wp,wg_prim] = margin(K_d*G)
mrg = 5
d_phi = PM_d - PM
d_phi_mrg = PM_d - PM + mrg


alpha = (1-sind(d_phi))/(1+sind(d_phi))

[d,u,v,wg_des] = margin(K_d*G/sqrt(alpha))

T = 1/(wg_des*sqrt(alpha))

z = -1/T
p = -1/(T*alpha)
ka = K_d/alpha
Aph = ka*tf([1 -z],[1 -p])

margin(Aph*G)

% reph

figure; hold on;

margin(G);
margin(K_d*G);

pha_des = -180+PM_d +5.75
wg_des = 0.4205 % trouve avec bode
beta = abs(evalfr(K_d*G,i*wg_des))
F = 10
zrph = -wg_des/F
T = F/wg_des
prph = -1/(beta*T)

Kr = K_d/beta

Grph = Kr*tf([1 -zrph],[1 -prph])
margin(Grph*G)


%c
BW_aph = bandwidth(feedback(Aph*G,1))
BW_rph = bandwidth(feedback(Grph*G,1))

%verif

t = [0:0.01:200];
u = t';
yaph = lsim(feedback(Aph*G,1),u,t)
yrph = lsim(feedback(Grph*G,1),u,t)
eaph = u-yaph;
erph = u-yrph;
figure;hold on;
plot(t,yaph);
plot(t,yrph);

figure;hold on;
plot(t,eaph);
plot(t,erph);

