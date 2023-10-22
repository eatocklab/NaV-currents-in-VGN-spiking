function II_array=EPSC_excitation_response(v,c,excitation,mag_mult)

tic
% global n_k_hh m_na_hh h_na_hh  
global a_k_rm b_k_rm c_k_rm mt_na_rm ht_na_rm mp_na_rm hp_na_rm br_na_rm hr_na_rm n_htk_rm p_htk_rm w_ltk_rm z_ltk_rm w_ltk_kv7 z_ltk_kv7 w_ltk_kvA z_ltk_kvA r_h_rm
global dt dur gb_syn VV plot_syn plot_EPSC time EPSC_shape Isyn %(added Isyn on 3/9/2016

tau=excitation; % the average II time

% For calculating the size of the array containing the synaptic excitation
if EPSC_shape==1
    EPSC_length=ceil(tau*9.5/dt);
elseif EPSC_shape==2
    EPSC_length=25/dt;
elseif EPSC_shape==3
    EPSC_length=52/dt;
end
    
% Preallocating large arrays
VV=zeros(1,dur/dt);
II=zeros(1,dur/5);

% Initial values to initiate backwards difference equations
V(1:2)=v;

[mi_t_rm variable] = inf_tau_mt_rm(V(1));
[hi_t_rm variable] = inf_tau_ht_rm(V(1));
[mi_p_rm] = inf_mp_rm(V(1));
[hi_p_rm] = 0;
[bi_r_rm] = 1;
[hi_r_rm variable] = inf_tau_hr_rm(V(1));

[ai_rm variable]=inf_tau_a_rm(V(1));
[bi_rm variable]=inf_tau_b_rm(V(1));
[ci_rm variable]=inf_tau_c_rm(V(1));
[ni_htk_rm variable]=inf_tau_n_htk_rm(V(1));
[pi_htk_rm variable]=inf_tau_p_htk_rm(V(1));
[wi_ltk_rm variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_rm variable]=inf_tau_z_ltk_rm(V(1));
[ri_h_rm variable]=inf_tau_r_rm(V(1));

[wi_ltk_kv7 variable]=inf_tau_w_ltkcnq_rm(V(1));  % initialize these values if you want to have a complex representation of IKL
[zi_ltk_kv7 variable]=inf_tau_z_ltkcnq_rm(V(1));
[wi_ltk_kvA variable]=inf_tau_w_ltk_rm(V(1));
[zi_ltk_kvA variable]=inf_tau_z_ltkA_rm(V(1));



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
r_h_rm(1:2)=ri_h_rm;

w_ltk_kv7(1:2)=wi_ltk_kv7; 
z_ltk_kv7(1:2)=zi_ltk_kv7;
w_ltk_kvA(1:2)=wi_ltk_kvA;
z_ltk_kvA(1:2)=zi_ltk_kvA;

gb_syn=0;

Il(3)=I_l(V(2));
Isyn(3)=I_syn(V(2));

Ina_rm=I_na_rm(V(2));
Ik_rm=I_k_rm(V(2));
Ihtk_rm=I_htk_rm(V(2));
Iltk_rm=I_ltk_rm(V(2));
Ih_rm=I_h_rm(V(2));

Il=I_l(V(2));
Isyn=I_syn(V(2));

V(3)=(-2*dt/c*(Isyn+Ina_rm+Ik_rm+Ihtk_rm+Iltk_rm+Ih_rm+Il)+4*V(2)-V(1))*1/3;

V(1)=V(2);
V(2)=V(3);


VV=(V);

% Generating the stimulus array
EPSC_train = plot_EPSC*10/mag_mult;  %generate_EPSC_train(EPSC_length,excitation); %plot_EPSC*10/mag_mult;  %
plot_EPSC = EPSC_train/10*mag_mult;  %EPSC_train/10*mag_mult; %EPSC converted to pA (/10), converted to scale factor (*mag_mult)
plot_syn=EPSC_train/10*mag_mult/97;  %EPSC converted to pA (/10), converted to scale factor (*mag_mult), and converted to conductance (/97 mV holding potential of recording)


for zz=4:dur/dt
            

    gb_syn=EPSC_train(zz)/10*mag_mult/97;
    
    % Updating currents from each type of channel
    Ina_rm=I_na_rm(V(2));
    Ik_rm=I_k_rm(V(2));
    Ihtk_rm=I_htk_rm(V(2));
    Iltk_rm=I_ltk_rm(V(2));
    Ih_rm=I_h_rm(V(2));
    
    % Updating currents from leak channel and synaptic conductances
    Il=I_l(V(2));
    Isyn=I_syn(V(2));
    
    % Calculating the new voltage value given the calculated currents
    V(3)=(-2*dt/c*(Isyn+Ina_rm+Ik_rm+Ihtk_rm+Iltk_rm+Ih_rm+Il)+4*V(2)-V(1))*1/3;
    

    % Updating new values for voltage buffer
    V(1)=V(2);
    V(2)=V(3);
    
    VV(zz)=V(3);   % for recording voltages
end

%% Spike Detection 

II_array=spike_detection(VV);

figure(69)
subplot(3,1,1)
plot(dt:dt:dur,VV); hold on % Plotting Voltages
title('Model Response to Synaptic Excitation')
xlabel('time (ms)')
ylabel('mV')
ylim([-100 100])
subplot(2,1,2)
plot(dt:dt:dur,plot_syn(1:dur/dt)); hold on
title('Synaptic Excitation')
xlabel('time (ms)')
ylabel('mV')
ylim([0 1.5])

II_array=II(2:length(II));

time=toc;