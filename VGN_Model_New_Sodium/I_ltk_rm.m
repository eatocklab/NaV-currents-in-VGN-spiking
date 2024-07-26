function I=I_ltk_rm(V)

global w_ltk_rm z_ltk_rm w_ltk_kv7 z_ltk_kv7 w_ltk_kvA z_ltk_kvA gb_ltk_rm dt Ek

% n=3 represents 'present' time value
n=3;
iklcomplex=1; %set to zero is you wish to run the model with Iltk being composed entirely of Kv1 components. Set to 1 if you want it to be a complex combination of channel subtypes.

% Calculate w & z infinity and w & z tau (time constant) as funciton of
% present V
[wi tau_w]=inf_tau_w_ltk_rm(V);
[zi tau_z]=inf_tau_z_ltk_rm(V);

w_ltk_rm(n)=(2*dt*(-w_ltk_rm(n-1)+wi)/tau_w+4*w_ltk_rm(n-1)-w_ltk_rm(n-2))*1/3;
z_ltk_rm(n)=(2*dt*(-z_ltk_rm(n-1)+zi)/tau_z+4*z_ltk_rm(n-1)-z_ltk_rm(n-2))*1/3;

% Update relative time of w value
w_ltk_rm(n-2)=w_ltk_rm(n-1);
w_ltk_rm(n-1)=w_ltk_rm(n);
% Update relative time of z value
z_ltk_rm(n-2)=z_ltk_rm(n-1);
z_ltk_rm(n-1)=z_ltk_rm(n);

% I=gb_ltk_rm*w_ltk_rm(n)^(4)*z_ltk_rm(n)*(V-Ek);

%%
if iklcomplex == 1

kv1 = 0.5; kv7= 0.5; kvA=0; % Define the proportion of the current conducted through either kv1, kv7, or kvA channels.  Note that net conductance is defined at the top level
%in Single_Compartment.m as a global variable.  Here you are simply
%defining proportions.

[wi_kv7 tau_w_kv7]=inf_tau_w_ltkcnq_rm(V);
[zi_kv7 tau_z_kv7]=inf_tau_z_ltkcnq_rm(V);
 
w_ltk_kv7(n)=(2*dt*(-w_ltk_kv7(n-1)+wi_kv7)/tau_w_kv7+4*w_ltk_kv7(n-1)-w_ltk_kv7(n-2))*1/3;
z_ltk_kv7(n)=(2*dt*(-z_ltk_kv7(n-1)+zi_kv7)/tau_z_kv7+4*z_ltk_kv7(n-1)-z_ltk_kv7(n-2))*1/3;
    % Update relative time of w value
    w_ltk_kv7(n-2)=w_ltk_kv7(n-1);
    w_ltk_kv7(n-1)=w_ltk_kv7(n);
    % Update relative time of z value
    z_ltk_kv7(n-2)=z_ltk_kv7(n-1);
    z_ltk_kv7(n-1)=z_ltk_kv7(n);

    [wi_kvA tau_w_kvA]=inf_tau_w_ltk_rm(V);
    [zi_kvA tau_z_kvA]=inf_tau_z_ltkA_rm(V);

    w_ltk_kvA(n)=(2*dt*(-w_ltk_kvA(n-1)+wi_kvA)/tau_w_kvA+4*w_ltk_kvA(n-1)-w_ltk_kvA(n-2))*1/3;
    z_ltk_kvA(n)=(2*dt*(-z_ltk_kvA(n-1)+zi_kvA)/tau_z_kvA+4*z_ltk_kvA(n-1)-z_ltk_kvA(n-2))*1/3;
    % Update relative time of w value
    w_ltk_kvA(n-2)=w_ltk_kvA(n-1);
    w_ltk_kvA(n-1)=w_ltk_kvA(n);
    % Update relative time of z value
    z_ltk_kvA(n-2)=z_ltk_kvA(n-1);
    z_ltk_kvA(n-1)=z_ltk_kvA(n);

    I = (kv1*gb_ltk_rm*w_ltk_rm(n)^4*z_ltk_rm(n) + kv7*gb_ltk_rm*w_ltk_kv7(n)^4*z_ltk_kv7(n) + kvA*gb_ltk_rm*w_ltk_kvA(n)^4*z_ltk_kvA(n))*(V-Ek);
else
I = gb_ltk_rm*w_ltk_rm(n)^(4)*z_ltk_rm(n)*(V-Ek);
end

end
