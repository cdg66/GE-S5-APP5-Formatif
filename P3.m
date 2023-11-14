clc;
clear all;
close all;

G1 = tf([1],[1 5])
G2 = tf([1],[1 11])
G3 = tf([1],[1 0])
Kp = 218.7;
G = G1*G2*G3*Kp



s = rlocus(G*Kp,1)
kvel = G.Numerator{1,1}(4)/G.Denominator{1,1}(3)
erp = 1/kvel
t = [0:0.01:10];
u = t';
figure;
lsim(feedback(G,1),u,t)

y = lsim(feedback(G,1),u,t)
figure; hold on;
plot(t,u-y)
y = u-y;
plot([t(1),t(end)], 0.98*y(end)*[1;1],'r')
plot([t(1),t(end)], 1.02*y(end)*[1;1],'r')

%b
clear all;

G1 = tf([1],[1 5])
G2 = tf([1],[1 11])
G3 = tf([1],[1 0])
Kp = 218.7;
G = G1*G2*G3


ts =2.73/2
Mp =30/2
erp = 0.25149/10
Kvel_d = 1/erp
phi = atand(-pi/(log(Mp/100)))

zetta = cosd(phi)

wn_d = 4/(ts*zetta)

p = -wn_d*zetta + wn_d*sqrt(1-zetta^2)*i

%aph 
figure;hold on;
rlocus(G)
plot(real(p),imag(p),'s')
plot(real(p),-imag(p),'s')

delta_phi = (-180)-((-360) + rad2deg(angle(evalfr(G,p)))) 
alpha = 180 - acosd(zetta)
phiz = (alpha+delta_phi)/2
phip = (alpha-delta_phi)/2

z = real(p)-imag(p)/tand(phiz)
p = real(p)-imag(p)/tand(phip)
tftest = tf([1 3.7782], [1 8.4886])
Gaph = tf([1 -z],[1 -p])
Ka = 1/abs(evalfr(G,p))
rlocus(G*Gaph)