function [V,varargout]=single_compart_second_rm_simpleCC(v,I,c)

% global n_k_hh m_na_hh h_na_hh
global a_k_rm b_k_rm c_k_rm mt_na_rm ht_na_rm mp_na_rm hp_na_rm br_na_rm hr_na_rm n_htk_rm p_htk_rm w_ltk_rm z_ltk_rm w_ltk_kv7 z_ltk_kv7 w_ltk_kvA z_ltk_kvA r_h_rm
global dt dur gb_syn I_print

% Preallocating large arrays
V=zeros(1,dur/dt);
if I_print==1
    Ina_rm=zeros(1,dur/dt);
    Ik_rm=zeros(1,dur/dt);
    Ihtk_rm=zeros(1,dur/dt);
    Iltk_rm=zeros(1,dur/dt);
    Ih_rm=zeros(1,dur/dt);
    Il=zeros(1,dur/dt);
    Isyn=zeros(1,dur/dt);
else
end

% Initial values to initiate backwards difference equations
V(1:2)= v;

[mi_t_rm variable] = inf_tau_mt_rm(V(1));
[hi_t_rm variable] = inf_tau_ht_rm(V(1));
[mi_p_rm] = inf_mp_rm(V(1));
[hi_p_rm] = 0;
[bi_r_rm] = 1; %; %initialize from 1, because no channels are blocked yet
[hi_r_rm variable] = inf_tau_hr_rm(V(1)); 

[ai_rm variable]=inf_tau_a_rm(V(1));
[bi_rm variable]=inf_tau_b_rm(V(1));
[ci_rm variable]=inf_tau_c_rm(V(1));
[ni_htk_rm variable]=inf_tau_n_htk_rm(V(1));
[pi_htk_rm variable]=inf_tau_p_htk_rm(V(1));
[wi_ltk_rm variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_rm variable]=inf_tau_z_ltk_rm(V(1));
[wi_ltk_kv7 variable]=inf_tau_w_ltkcnq_rm(V(1));
[zi_ltk_kv7 variable]=inf_tau_z_ltkcnq_rm(V(1));
[wi_ltk_kvA variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_kvA variable]=inf_tau_z_ltkA_rm(V(1));
[ri_h_rm variable]=inf_tau_r_rm(V(1));

mt_na_rm(1:2)=mi_t_rm;
ht_na_rm(1:2)=hi_t_rm;
mp_na_rm(1:2)=mi_p_rm;
hp_na_rm(1:2)=hi_p_rm;
br_na_rm(1:2)=bi_r_rm;
hr_na_rm(1:2)=hi_r_rm;

a_k_rm(1:2)=ai_rm;
b_k_rm(1:2)=bi_rm;
c_k_rm(1:2)=ci_rm;
n_htk_rm(1:2)=ni_htk_rm;
p_htk_rm(1:2)=pi_htk_rm;
w_ltk_rm(1:2)=wi_ltk_rm;
z_ltk_rm(1:2)=zi_ltk_rm;
w_ltk_kv7(1:2)=wi_ltk_kv7;
z_ltk_kv7(1:2)=zi_ltk_kv7;
w_ltk_kvA(1:2)=wi_ltk_kvA;
z_ltk_kvA(1:2)=zi_ltk_kvA;
r_h_rm(1:2)=ri_h_rm;

gb_syn=0;


Ina_rm=I_na_rm(V(2));
% Ik_rm=I_k_rm(V(2));
Ihtk_rm=I_htk_rm(V(2));
Iltk_rm=I_ltk_rm(V(2));
Ih_rm=I_h_rm(V(2));

Il=I_l(V(2));
Isyn=I_syn(V(2));

V(3)=(-2*dt/c*(-I(3)+Ina_rm+Ihtk_rm+Iltk_rm+Ih_rm+Il)+4*V(2)-V(1))*1/3;

for zz=4:dur/dt
    
    Ina_rm=I_na_rm(V(zz-1));
%     Ik_rm=I_k_rm(V(zz-1));
    Ihtk_rm=I_htk_rm(V(zz-1));
    Iltk_rm=I_ltk_rm(V(zz-1));
    Ih_rm=I_h_rm(V(zz-1));
    Il=I_l(V(zz-1));
    Isyn=I_syn(V(zz-1));
    V(zz)=(-2*dt/c*(-I(zz)+Isyn+Ina_rm+Ihtk_rm+Iltk_rm+Ih_rm+Il)+4*V(zz-1)-V(zz-2))*1/3;
    
end