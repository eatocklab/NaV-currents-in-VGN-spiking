function [V,varargout]=single_compart_second_rm(v,I,c,cs,trial,epsc_amp_94)

% global n_k_hh m_na_hh h_na_hh  
global a_k_rm b_k_rm c_k_rm mt_na_rm ht_na_rm mp_na_rm hp_na_rm br_na_rm hr_na_rm n_htk_rm p_htk_rm w_ltk_rm z_ltk_rm w_ltk_kv7 z_ltk_kv7 w_ltk_kvA z_ltk_kvA r_h_rm
global dt dur gb_syn I_print Na_print 

% Preallocating large arrays
V=zeros(1,dur/dt);
if I_print==1
    Ina_rm=zeros(1,dur/dt);
    Ina_t_rm=zeros(1,dur/dt);
    Ina_r_rm=zeros(1,dur/dt);
    Ina_p_rm=zeros(1,dur/dt);
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

if cs==1
    gb_syn=epsc_amp_94(3)/97;
else
    gb_syn=0;
end

if I_print==1
    [Ina_rm(3), Ina_t_rm(3), Ina_p_rm(3), Ina_r_rm(3)] = I_na_rm(V(2));
    Ik_rm(3)=I_k_rm(V(2));
    Ihtk_rm(3)=I_htk_rm(V(2));
    Iltk_rm(3)=I_ltk_rm(V(2));
    Ih_rm(3)=I_h_rm(V(2));
    
    Il(3)=I_l(V(2));
    Isyn(3)=I_syn(V(2));

    V(3)=(-2*dt/c*(-I(3)+Isyn(3)+Ina_rm(3)+Ik_rm(3)+Ihtk_rm(3)+Iltk_rm(3)+Ih_rm(3)+Il(3))+4*V(2)-V(1))*1/3;
else
    Ina_rm=I_na_rm(V(2));
    Ik_rm=I_k_rm(V(2));
    Ihtk_rm=I_htk_rm(V(2));
    Iltk_rm=I_ltk_rm(V(2));
    Ih_rm=I_h_rm(V(2));
    
    Il=I_l(V(2));
    Isyn=I_syn(V(2));
    
    V(3)=(-2*dt/c*(-I(3)+Isyn+Ina_rm+Ik_rm+Ihtk_rm+Iltk_rm+Ih_rm+Il)+4*V(2)-V(1))*1/3;
end

for zz=4:dur/dt
    
    if cs==1
        % Updating g_syn
        gb_syn=epsc_amp_94(zz)/97;
    end

    if I_print==1
        [Ina_rm(zz),Ina_t_rm(zz),Ina_p_rm(zz),Ina_r_rm(zz)] = I_na_rm(V(zz-1));
        Ik_rm(zz)=I_k_rm(V(zz-1));
        Ihtk_rm(zz)=I_htk_rm(V(zz-1));
        Iltk_rm(zz)=I_ltk_rm(V(zz-1));
        Ih_rm(zz)=I_h_rm(V(zz-1));
        Il(zz)=I_l(V(zz-1));
        Isyn(zz)=I_syn(V(zz-1));
        V(zz)=(-2*dt/c*(-I(zz)+Isyn(zz)+Ina_rm(zz)+Ik_rm(zz)+Ihtk_rm(zz)+Iltk_rm(zz)+Ih_rm(zz)+Il(zz))+4*V(zz-1)-V(zz-2))*1/3;
    else
        Ina_rm=I_na_rm(V(zz-1));
        Ik_rm=I_k_rm(V(zz-1));
        Ihtk_rm=I_htk_rm(V(zz-1));
        Iltk_rm=I_ltk_rm(V(zz-1));
        Ih_rm=I_h_rm(V(zz-1));
        Il=I_l(V(zz-1));
        Isyn=I_syn(V(zz-1));
        V(zz)=(-2*dt/c*(-I(zz)+Isyn+Ina_rm+Ik_rm+Ihtk_rm+Iltk_rm+Ih_rm+Il)+4*V(zz-1)-V(zz-2))*1/3;
    end
end

if I_print==1
    p_t=dt:dt:dur;
    if trial==1 && cs==1
        figure(10)
        subplot(2,3,1)
       plot(p_t,V)
        title('Type 1-c Cell Response to Spontaneous EPSP ''spiking''')
       ylabel('Voltage (mV)')
        xlabel('time(ms)')
        subplot(2,3,2)
        plot(p_t,Ina_rm*10)
        title('Type 1-c Cell: Ina under spontaneous EPSP ''spiking''')
        ylabel('current (pA)')
        xlabel('time(ms)')
        subplot(2,3,3)
        plot(p_t,Ihtk_rm*10)
        title('Type 1-c Cell: Ihtk under spontaneous EPSP ''spiking''')
        ylabel('current (pA)')
        xlabel('time(ms)')
        subplot(2,3,4)
        plot(p_t,Isyn*10)
        title('Type 1-c Cell: Isyn under spontaneous EPSP ''spiking''')
        ylabel('current (pA)')
        xlabel('time(ms)')
        subplot(2,3,5)
        plot(p_t,Ih_rm*10)
        title('Type 1-c Cell: Ih under spontaneous EPSP ''spiking''')
        ylabel('current (pA)')
        xlabel('time(ms)')
        subplot(2,3,6)
        plot(p_t,Il*10)
        title('Type 1-c Cell: Il under spontaneous EPSP ''spiking''')
        ylabel('current (pA)')
        xlabel('time(ms)')
    elseif trial==1 && cs==2
        figure(20)
        subplot(2,3,1)
        plot(p_t,V)
        title(['Type 1-c Cell Response to ',num2str(max(I)*10),' pA Current Clamp'])
        subplot(2,3,2)
        plot(p_t,Ina_rm); hold on
        title('Type 1-c Cell: Ina under current clamp')
        subplot(2,3,3)
        plot(p_t,Ihtk_rm); hold on
        title('Type 1-c Cell: Ihtk under current clamp')
        subplot(2,3,4)
        plot(p_t,Isyn); hold on
        title('Type 1-c Cell: Isyn under current clamp')
        subplot(2,3,5)
        plot(p_t,Ih_rm); hold on
        title('Type 1-c Cell: Ih under current clamp')
        subplot(2,3,6)
        plot(p_t,Il); hold on
        title('Type 1-c Cell: Il under current clamp')
    elseif trial==2 && cs==1
        figure(30)
        subplot(2,3,1)
        plot(V)
        title('Type II Cell Response to Spontaneous EPSP ''spiking''')
        subplot(2,3,2)
        plot(Ina_rm)
        title('Type II Cell: Ina under spontaneous EPSP ''spiking''')
        subplot(2,3,3)
        plot(Ihtk_rm)
        title('Type II Cell: Ihtk under spontaneous EPSP ''spiking''')
        subplot(2,3,4)
        plot(Iltk_rm)
        title('Type II Cell: Iltk under spontaneous EPSP ''spiking''')
        subplot(2,3,5)
        plot(Ih_rm)
        title('Type II Cell: Ih under spontaneous EPSP ''spiking''')
        subplot(2,3,6)
        plot(Il)
        title('Type II Cell: Il under spontaneous EPSP ''spiking''')
    else
        figure(40)
        subplot(2,3,1)
        plot(p_t,V)
        title(['Type II Cell Response to ',num2str(max(I)*10),' pA Current Clamp'])
        subplot(2,3,2)
        plot(p_t,Ina_rm); hold on
        title('Type II Cell: Ina under current clamp')
        subplot(2,3,3); hold on
        plot(p_t,Ihtk_rm)
        title('Type II Cell: Ihtk under current clamp')
        subplot(2,3,4)
        plot(p_t,Iltk_rm); hold on
        title('Type II Cell: Iltk under current clamp')
        subplot(2,3,5)
        plot(p_t,Ih_rm); hold on
        title('Type II Cell: Ih under current clamp')
        subplot(2,3,6)
        plot(p_t,Il); hold on
        title('Type II Cell: Il under current clamp')
    end
    
    Ioutput.Ina_rm = Ina_rm(:);
    Ioutput.Ina_t_rm = Ina_t_rm(:);
    Ioutput.Ina_r_rm = Ina_r_rm(:);
    Ioutput.Ina_p_rm = Ina_p_rm(:);
    Ioutput.Ik_rm = Ik_rm(:);
    Ioutput.Ihtk_rm = Ihtk_rm(:); 
    Ioutput.Iltk_rm = Iltk_rm(:);
    Ioutput.Ih_rm = Ih_rm(:);
    Ioutput.Il = Il(:);
    Ioutput.Isyn=Isyn(:);
    varargout={Ioutput};
end
    
if Na_print == 1
    p_t=dt:dt:dur;
    figure(42)
    subplot(1,3,1)
    plot(p_t,Ina_t_rm*10)
    title('I-NaVT during spiking')
    ylabel('current (pA)')
    xlabel('time(ms)')
    subplot(1,3,2)
    plot(p_t,Ina_p_rm*10)
    title('I-NaVP during spiking')
    ylabel('current (pA)')
    xlabel('time(ms)')
    subplot(1,3,3)
    plot(p_t,Ina_r_rm*10)
    title('I-NaVR during spiking')
    ylabel('current (pA)')
    xlabel('time(ms)')
end
