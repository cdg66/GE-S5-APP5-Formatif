clc;
close all;
clear;

G = tf([1 2 1],[1 2 2 1 0])

erp = 0.005;
Mp = 10%
ts = 1;
Kvel = 1/erp
phi = atand(-pi/log(Mp/100))

zetta = cosd(phi)

wn_d = 4/(ts*zetta)

p = [(-zetta*wn_d + i*wn_d*sqrt(1-zetta^2));( -zetta*wn_d - i*wn_d*sqrt(1-zetta^2))]

%aph
figure; hold on;
rlocus(G,'r')
plot(real(p),imag(p),'p')
comp = 2
d_phi = (-180) - ((-360)+rad2deg(angle(evalfr(G,p(1)))))+comp

alpha = 180 -phi

phiz = (alpha+d_phi)/2
phip = (alpha-d_phi)/2
RE = real(p(1))
IM = imag(p(1))
za = RE - IM/tand(phiz)
pa = RE - IM/tand(phip)

Ga = tf([1 -za],[1 -pa])
Ka = 1/abs(evalfr(Ga*G,p(1)))
rlocus(Ka*Ga*G,'g')
p2 = rlocus(Ka*Ga*G,1)
plot(real(p2),imag(p2),'s')

%reph
GaG = Ka*Ga*G
K = Kvel/(GaG.Numerator{1,1}(end)/GaG.Denominator{1,1}(end-1))
F = 10
zr = RE/F
pr = zr/K
Gr = tf([1 -zr],[1 -pr])
Kr = 1/abs(evalfr(Gr*GaG,p(1)))

rlocus(Kr*Gr*GaG)
rlocus(Kr*Gr*GaG)
p2 = rlocus(Kr*Gr*GaG,1)
plot(real(p2),imag(p2),'p')

%verif 
TF = Kr*Gr*GaG
t = [0:0.1:15]
u = t';
y = lsim(feedback(TF,1),u,t);
err = u -y;
figure; 
plot(t,err)
figure;
step(feedback(TF,1))
[y2,t] = step(feedback(TF,1));
sys = stepinfo(y2,t)
Mp = (max(y2)-y2(end))/y2(end)
ts = sys.SettlingTime
