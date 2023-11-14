clc;
close all;
clear all;

G1 = tf([1],[1 8])
G2 = tf([1],[1 30])
G3 = tf([1],[1 0])
G = G1*G2*G3

tp = 0.4 %s
Mp = 10 %
eRP = 0.05

Kvel_d = 1/eRP

phi = atand(-pi/log(Mp/100))

zetta = cosd(phi)

PM_d = atand((2*zetta)/(sqrt(sqrt(1+4*zetta^4)-2*zetta^2)))


wn_d = pi/(tp*sqrt(1-zetta^2))
wg = (2*zetta*wn_d)/tand(PM_d)

%reph

figure; hold on;
margin(G)

[mag,pha] = bode(G,wg)
Kdes = 1/mag
marge = 5
margin(G*Kdes)
PM = pha-(-180)
delta_phi = (PM_d - PM )+marge

alpha = (1-sind(delta_phi))/(1+sind(delta_phi))
Taph = 1/(wg*sqrt(alpha))
z = -1/Taph
p = -1/(alpha*Taph)

Ka = Kdes/sqrt(alpha)

Gaph = Ka*tf([1 -z],[1 -p])

margin(Gaph*G)

%reph
G2 = Gaph*G
Kvel = G2.Numerator{1,1}(5)/G2.Denominator{1,1}(4)
K2 = Kvel_d/Kvel

[Beta,pha] = bode(K2*G2,wg)
F = 10
zph = -wg/10
Trph = F/wg
pph = -1/(Beta*Trph)
Grph = tf([1 -zph],[1 -pph])

Kr = K2/(Beta*abs(evalfr(Grph,i*wg)))
Gf = Grph*Kr*G2
margin(Gf)

%% test

t = [0:0.01:15];
u = t';
figure; hold on;
%lsim(feedback(Gf,1),u,t)
y = lsim(feedback(Gf,1),u,t)
plot(t,u-y)
z = u -y;
Mp = (max(z)-z(end))/z(end)
