
% clear all
% load('C:\Users\baeza\OneDrive\Desktop\Model_data\EPSC_mag\SusCon_V_mag0_5.mat');
% load('C:\Users\baeza\OneDrive\Desktop\Model_data\EPSC_mag\time.mat');
% load('E:\Grad School\MATLAB\Sustained-B_0.91_IH conditions\Spikes Data\Spike Trains\0.20-0.80_IKL_splitKvs_max-activation_spiketrain.mat');
    
exp = 1; % 1 = no batch, 2 = batch 

if exp == 1
    spikes(1) = spike_CV(VV, time_array, -20);
else
    for n=1:5
    spikes(n) = spike_CV(V(n,:),time_array, -20);
    end
end

% spikes(1) = spike_CV(V,time_array, -20);
    



% cd('C:\Users\baeza\OneDrive\Desktop\Modeling\Results\EPSCsims\') % Change directory for where you wish to save
% filename=input('EnterFileName:','s');
% save(filename,'spikes'); %Output data structure is defined in lines near.