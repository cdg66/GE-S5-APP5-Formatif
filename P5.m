clc;
close all;
clear all;

G1 = tf([1 8],[1 3])
G2 = tf([1],[1 6])
G3 = tf([1],[1 10])

G = G1*G2*G3

Mp = 20%
ts = 0.7%s

phi = atand(-pi/log(Mp/100))

zetta = cosd(phi)
wn_d = 4/(zetta*ts)

p = -zetta*wn_d + i*wn_d*sqrt(1 - zetta^2)
% a PD G(s)/s

G_s = G*tf([1],[1 0])
phase_comp = -360+rad2deg(angle(evalfr(G_s,p)))
delta_phi = (-180)-phase_comp

z = real(p) - imag(p)/tand(delta_phi/2)
pd = tf([1 -z],[1])
PD = pd*pd

Kd = 1 / abs(evalfr(PD*G_s,p))
p_d = [p;real(p)-i*imag(p)]

%plot rlocus
figure;hold on;
rlocus(G,'r')
rlocus(G_s,'b')
rlocus(G_s*Kd*PD, 'g')
ploles_obt = rlocus(G_s*Kd*PD,1)
plot(real(ploles_obt),imag(ploles_obt),'s')
plot(real(p_d),imag(p_d),"p")

%verif erreur

t = [0:0.01:15];
u = t';

y = lsim(feedback(G_s*Kd*PD,1),u,t)
figure;
err = u-y
plot(t,err)

Mp = (max(err)-err(end))/err(end)

figure;
step(feedback(G_s*Kd*PD,1))
[y,t] = step(feedback(G_s*Kd*PD,1))
sys = stepinfo(y,t)

%b

%PD
%close all;
phase_comp = -360+rad2deg(angle(evalfr(G,p)))
delta_phi = (-180)-phase_comp
z = real(p) - imag(p)/tand(delta_phi)
pd = tf([1 -z],[1])
Kd = 1/abs(evalfr(pd*G,p))

%PI
F = 2
zpi = real(p)/F
pi_d = tf([1 -zpi],[1 0])
Kp = 1/abs(evalfr(G*Kd*pd*pi_d,p))


%plot rlocus
figure;hold on;
rlocus(G,'r')
rlocus(G*Kd*pd, 'g')
rlocus(G*Kd*pd*Kp*pi_d, 'b')
ploles_obt = rlocus(G*Kd*pd*Kp*pi_d,1)
plot(real(ploles_obt),imag(ploles_obt),'s')
plot(real(p_d),imag(p_d),"p")

%verif erreur

t = [0:0.01:15];
u = t';

y = lsim(feedback(G*Kd*pd*Kp*pi_d,1),u,t)
figure;
err = u-y
plot(t,err)

Mp = (max(err)-err(end))/err(end)

figure;
step(feedback(G*Kd*pd*Kp*pi_d,1))
[y,t] = step(feedback(G*Kd*pd*Kp*pi_d,1))
sys2 = stepinfo(y,t)

