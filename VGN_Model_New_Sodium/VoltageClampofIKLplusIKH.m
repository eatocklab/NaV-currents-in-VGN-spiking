global gb_ltk_rm gb_htk_rm
global  Ek
global dt dur
global w_ltk_rm z_ltk_rm 
global dt dur
dur=1000;                       % time duration (ms)
dt=0.01;                        % delta t (ms)
Ek=-80.78;                      %K battery (mV)
gb_ltk_rm=1.1;                  % max conductance value
gb_htk_rm=2.8;

time = [0:dt:dur];
V=ones(1,dur/dt+1);
r = 0.25.*randn(10,1);
r1 = 0.25.*randn(10,1)
a=2;
for k = 1:length(r);
    
Vsteps=[-90:5:0];
for l = 1:length(Vsteps)
V(1:100000)=-120;
%V(100000/2:100000/2+3)=[-60,-55,-50,-45];
V(100000/2+4:end)=Vsteps(l);
% figure(1)
% plot(time,V,'k'); hold on

Iltk_rm=zeros(1,dur/dt);
[wi_ltk_rm variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_rm variable]=inf_tau_z_ltk_rm(V(1));
w_ltk_rm(1:2)=wi_ltk_rm;
z_ltk_rm(1:2)=zi_ltk_rm;


Ihtk_rm=zeros(1,dur/dt);
[ni_htk_rm v2]=inf_tau_n_htk_rm(V(1));
[pii_htk_rm v2]=inf_tau_p_htk_rm(V(1));
n_htk_rm(1:2)=ni_htk_rm;
p_htk_rm(1:2)=pii_htk_rm;


    for m=1:length(V);
    n=3;
    [wi tau_w]=inf_tau_w_ltk_rm(V(m));
    [zi tau_z]=inf_tau_z_ltk_rm(V(m));
    w_ltk_rm(n)=(2*dt*(-w_ltk_rm(n-1)+wi)/tau_w+4*w_ltk_rm(n-1)-w_ltk_rm(n-2))*1/3;
    z_ltk_rm(n)=(2*dt*(-z_ltk_rm(n-1)+zi)/tau_z+4*z_ltk_rm(n-1)-z_ltk_rm(n-2))*1/3;
    w_ltk_rm(n-1)=w_ltk_rm(n);
    w_ltk_rm(n-2)=w_ltk_rm(n-1);
    z_ltk_rm(n-2)=z_ltk_rm(n-1);
    z_ltk_rm(n-1)=z_ltk_rm(n);
    Iltk_rm(m)=a*(gb_ltk_rm+r(k))*w_ltk_rm(n)^(4)*z_ltk_rm(n)*(V(m)-Ek);
    %Iltk_rm(m)=(gb_ltk_rm)*w_ltk_rm(n)^(4)*z_ltk_rm(n)*(V(m)-Ek);
    
    
    [ni tau_n]=inf_tau_n_htk_rm(V(m));
    [pii tau_p]=inf_tau_p_htk_rm(V(m));
    n_htk_rm(n)=(2*dt*(-n_htk_rm(n-1)+ni)/tau_n+4*n_htk_rm(n-1)-n_htk_rm(n-2))*1/3;
    p_htk_rm(n)=(2*dt*(-p_htk_rm(n-1)+pii)/tau_p+4*p_htk_rm(n-1)-p_htk_rm(n-2))*1/3;

    % Update relative time of n value
    n_htk_rm(n-2)=n_htk_rm(n-1);
    n_htk_rm(n-1)=n_htk_rm(n);
    % Update relative time of p value
    p_htk_rm(n-2)=p_htk_rm(n-1);
    p_htk_rm(n-1)=p_htk_rm(n);
    phi=0.85;
    
    Ihtk(m)=a*(gb_htk_rm+r(k))*(phi*n_htk_rm(n)^2+(1-phi)*p_htk_rm(n))*(V(m)-Ek);
    end

Iss(l) = Iltk_rm(90001)+Ihtk(90001) % at 900 ms;
gss(l) = Iss(l)./(Vsteps(l)-Ek);
% figure(2)
% subplot(211)
% plot(time, Iltk_rm,'b'); hold on
% plot(time, Ihtk,'g'); hold on
% subplot(212)
% plot(time, V,'k') ; hold on
end

X(k).Iss = Iss;
X(k).gss = gss;
figure(3)
subplot(311)
plot(Vsteps,Iss,'g','Linewidth',1); hold on
subplot(312)
plot(Vsteps,gss,'g','Linewidth',1); hold on
subplot(313)
%plot(Vsteps,Iss/max(Iss),'m','Linewidth',1); hold on
plot(Vsteps,gss./max(gss),'g','Linewidth',1); hold on
end