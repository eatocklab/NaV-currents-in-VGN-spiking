global gb_ltk_rm
global  Ek
global dt dur
global w_ltk_rm z_ltk_rm
global dt dur
dur=1000;                       % time duration (ms)
dt=0.01;                        % delta t (ms)
Ek=-80.78;                      %K battery (mV)
gb_ltk_rm=1.1;                  % max conductance value
time = [0:dt:dur];
V=ones(1,dur/dt+1);

V(1:100000)=-120;
V(100000/2:100000/2+3)=[-60,-55,-50,-45];
V(100000/2+4:end)=-45;

%plot(time,V,'r')
iklcomplex=1;
Iltk_rm=zeros(1,dur/dt);

[wi_ltk_rm variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_rm variable]=inf_tau_z_ltk_rm(V(1));
w_ltk_rm(1:2)=wi_ltk_rm;
z_ltk_rm(1:2)=zi_ltk_rm;

[wi_ltk_kv7 variable]=inf_tau_w_ltkcnq_rm(V(1));
[zi_ltk_kv7 variable]=inf_tau_z_ltkcnq_rm(V(1));
w_ltk_kv7(1:2)=wi_ltk_kv7;
z_ltk_kv7(1:2)=zi_ltk_kv7;

[wi_ltk_kvA variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_kvA variable]=inf_tau_z_ltkA_rm(V(1));
w_ltk_kvA(1:2)=wi_ltk_kvA;
z_ltk_kvA(1:2)=zi_ltk_kvA;

for m=1:length(V);
n=3;
[wi tau_w]=inf_tau_w_ltk_rm(V(m));
[zi tau_z]=inf_tau_z_ltk_rm(V(m));

w_ltk_rm(n)=(2*dt*(-w_ltk_rm(n-1)+wi)/tau_w+4*w_ltk_rm(n-1)-w_ltk_rm(n-2))*1/3;
z_ltk_rm(n)=(2*dt*(-z_ltk_rm(n-1)+zi)/tau_z+4*z_ltk_rm(n-1)-z_ltk_rm(n-2))*1/3;

% Update relative time of w value
w_ltk_rm(n-2)=w_ltk_rm(n-1);
w_ltk_rm(n-1)=w_ltk_rm(n);
% Update relative time of z value
z_ltk_rm(n-2)=z_ltk_rm(n-1);
z_ltk_rm(n-1)=z_ltk_rm(n);

    if iklcomplex == 1
    kv1 = 0; kv7=0; kvA=0.2;

    [wi_kv7 tau_w_kv7]=inf_tau_w_ltkcnq_rm(V(m));
    [zi_kv7 tau_z_kv7]=inf_tau_z_ltkcnq_rm(V(m));
 
    w_ltk_kv7(n)=(2*dt*(-w_ltk_kv7(n-1)+wi_kv7)/tau_w_kv7+4*w_ltk_kv7(n-1)-w_ltk_kv7(n-2))*1/3;
    z_ltk_kv7(n)=(2*dt*(-z_ltk_kv7(n-1)+zi_kv7)/tau_z_kv7+4*z_ltk_kv7(n-1)-z_ltk_kv7(n-2))*1/3;
    % Update relative time of w value
    w_ltk_kv7(n-2)=w_ltk_kv7(n-1);
    w_ltk_kv7(n-1)=w_ltk_kv7(n);
    % Update relative time of z value
    z_ltk_kv7(n-2)=z_ltk_kv7(n-1);
    z_ltk_kv7(n-1)=z_ltk_kv7(n);

    [wi_kvA tau_w_kvA]=inf_tau_w_ltk_rm(V(m));
    [zi_kvA tau_z_kvA]=inf_tau_z_ltkA_rm(V(m));

    w_ltk_kvA(n)=(2*dt*(-w_ltk_kvA(n-1)+wi_kvA)/tau_w_kvA+4*w_ltk_kvA(n-1)-w_ltk_kvA(n-2))*1/3;
    z_ltk_kvA(n)=(2*dt*(-z_ltk_kvA(n-1)+zi_kvA)/tau_z_kvA+4*z_ltk_kvA(n-1)-z_ltk_kvA(n-2))*1/3;
    % Update relative time of w value
    w_ltk_kvA(n-2)=w_ltk_kvA(n-1);
    w_ltk_kvA(n-1)=w_ltk_kvA(n);
    % Update relative time of z value
    z_ltk_kvA(n-2)=z_ltk_kvA(n-1);
    z_ltk_kvA(n-1)=z_ltk_kvA(n);

    Iltk_rm(m) = (kv1*gb_ltk_rm*w_ltk_rm(n)^4*z_ltk_rm(n) + kv7*gb_ltk_rm*w_ltk_kv7(n)^4*z_ltk_kv7(n) + kvA*gb_ltk_rm*w_ltk_kvA(n)^4*z_ltk_kvA(n))*(V(m)-Ek);
    else 
    % Calculate w & z infinity and w & z tau (time constant) as funciton of
    % present V
    Iltk_rm(m)=gb_ltk_rm*w_ltk_rm(n)^(4)*z_ltk_rm(n)*(V(m)-Ek);
    end
end

subplot(211)
plot(time, Iltk_rm,'b'); hold on
subplot(212)
plot(time, V,'k') ; hold on