function [I, I_na_t,I_na_p, I_na_r] = I_na_rm(V)
global mt_na_rm ht_na_rm mp_na_rm hp_na_rm br_na_rm hr_na_rm gb_na_rm gb_na_r_rm gb_na_p_rm Ena dt
n=3;

%Calculate m & h infinity and m & h tau (time constant) as function of V
%transient Na current
[mi_t, tau_m_t] = inf_tau_mt_rm(V); 
[hi_t, tau_h_t] = inf_tau_ht_rm(V);

mt_na_rm(n) = (2*dt*(-mt_na_rm(n-1)+mi_t)/tau_m_t+4*mt_na_rm(n-1)-mt_na_rm(n-2))*1/3;
ht_na_rm(n) = (2*dt*(-ht_na_rm(n-1)+hi_t)/tau_h_t+4*ht_na_rm(n-1)-ht_na_rm(n-2))*1/3;

%persistent Na current

mi_p = inf_mp_rm(V);
[hi_p, tau_h_p] = inf_hp_rm(V);

mp_na_rm(n) = mi_p; 
hp_na_rm(n) = (2*dt*(-hp_na_rm(n-1)+hi_p)/tau_h_p+4*hp_na_rm(n-1)-hp_na_rm(n-2))*1/3; 

%resurgent Na current: b = unblocking, h = inactivation
alphab = 0.08;   % rate of unblocking, 0.08-0.1
kb = 0.9;       %0.8 - 1.2

[bi_r, betabr] = inf_tau_br_rm(V);
[hi_r, alphahr, betahr] = inf_tau_hr_rm(V);

br_na_rm(n) = (2*dt*(alphab*(1-br_na_rm(n-1))*bi_r - kb*betabr*br_na_rm(n-1))+4*br_na_rm(n-1)-br_na_rm(n-2))*1/3;
hr_na_rm(n) = (2*dt*(alphahr*hi_r - 0.8*betahr*hr_na_rm(n-1))+4*hr_na_rm(n-1)-hr_na_rm(n-2))*1/3;

% Update relative time of m, h, and b values

mt_na_rm(n-2) = mt_na_rm(n-1);
mt_na_rm(n-1) = mt_na_rm(n);

ht_na_rm(n-2) = ht_na_rm(n-1);
ht_na_rm(n-1) = ht_na_rm(n);

mp_na_rm(n-2) = mp_na_rm(n-1);
mp_na_rm(n-1) = mp_na_rm(n);

hp_na_rm(n-2) = hp_na_rm(n-1);
hp_na_rm(n-1) = hp_na_rm(n);

br_na_rm(n-2) = br_na_rm(n-1);
br_na_rm(n-1) = br_na_rm(n);

hr_na_rm(n-2) = hr_na_rm(n-1);
hr_na_rm(n-1) = hr_na_rm(n);

% Calculate individual current components
% Transient na current
I_na_t = gb_na_rm*(mt_na_rm(n)^3)*ht_na_rm(n)*(V-Ena);
% Persistent na current
I_na_p = gb_na_p_rm*(mp_na_rm(n)*hp_na_rm(n))*(V-Ena);
% Resurgent na current
I_na_r = gb_na_r_rm*((1-br_na_rm(n))^3)*(hr_na_rm(n)^5)*(V-Ena);

% Sum and return 
I = I_na_t + I_na_p + I_na_r;
end