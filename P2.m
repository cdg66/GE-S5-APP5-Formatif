clc;
close all;
clear all;

G1 = tf([1],[1 2])
G2 = tf([1],[1 3])

G = G1*G1*G2
%a
ts_d = 1.6 %s
Mp_d = 25 %
phi = atand(-pi/log(Mp_d/100))
zetta = cosd(phi)
wn_d = 4/(ts_d*zetta)

p_d = [-(4/ts_d) + i* wn_d*sqrt(1-zetta^2);-(4/ts_d) - i* wn_d*sqrt(1-zetta^2)]

%b
figure;hold on;
rlocus(G)
p = rlocus(G,1)
plot(real(p),imag(p),'p')
plot(real(p_d),imag(p_d),'s')

phase_sys = (-360 + rad2deg(angle(evalfr(G,p_d(1)))) ) 
delta_phi = (-180)-phase_sys

Re = real(p_d(1))
Im = imag(p_d(1))

phi_z = atand(Im/(Re+1))+180

phi_p = -(delta_phi - phi_z)

%c
z = -1
p = Re-Im/tand(phi_p)

%d
Gaph = tf([1 -z],[1 -p])

Ka = 1/abs(evalfr(Gaph*G,p_d(1)))

KaGaph = Ka*Gaph
%e
figure;hold on;
rlocus(G,'r')
p = rlocus(G,1)
plot(real(p),imag(p),'p')
plot(real(p_d),imag(p_d),'s')
rlocus(G*KaGaph,'b')

%f

figure;hold on;
t = [0:0.01:20];
u = ones(size(t));
lsim(feedback(G*KaGaph,1),u,t)
y = lsim(feedback(G*KaGaph,1),u,t)
plot([t(1);t(end)],0.98*y(end)*[1;1],"r")

plot([t(1);t(end)],1.02*y(end)*[1;1],"r")

%g
phi_p_2 = -(delta_phi - (phi_z+phi_z))/2

p2 = Re-Im/tand(phi_p_2)

Gaph2 = tf([1 -z], [1 -p2 ])
Gaph2 = Gaph2*Gaph2;
Ka2 = 1/abs(evalfr(Gaph2*G,p_d(1)))
Ka2Gaph2 = Ka2*Gaph2

figure;hold on;
rlocus(G,'r');
plot(real(p),imag(p),'p')
plot(real(p_d),imag(p_d),'s')
rlocus(G*Ka2Gaph2,'b')
p = rlocus(G*Ka2Gaph2,1)
plot(real(p),imag(p),'p')