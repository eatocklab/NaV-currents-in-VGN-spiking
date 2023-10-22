num_exp = 10 ;
[spike_count, mean_ISI, CV, spike_height] = deal(zeros(1, num_exp));

for i = 1:num_exp
    %%
    Single_Compartment_Annotated;
    
%     filename_o = (['SustainedCPR_Outputdata_trail_' num2str(i)]);
%     cd('C:\Users\baeza\OneDrive\Desktop\Modeling\Results\EPSCsims\batch0\SustainedCPR'); % Change directory for where you wish to save
%     save(filename_o,'Outputdata'); %Output data structure is defined in lines near 463.
    
    %%
%     cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium'); % Change directory for where you wish to save
    
    Spikes_count_CV;
    spike_count(i) = spikes.spikenum;
    mean_ISI(i) = spikes.mean_ISI;
    CV(i) = spikes.CV;
    spike_height(i) = spikes.mean_spikeheight;
    
    
%     filename_s = (['SustainedCPR_spikes_trail_' num2str(i)]);
%     cd('C:\Users\baeza\OneDrive\Desktop\Modeling\Results\EPSCsims\batch0\SustainedCPR'); % Change directory for where you wish to save
%     save(filename_s,'spikes')
    
%     cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium'); % Change directory for where you wish to save
    
end

FF = var(spike_count)/mean(spike_count);
disp(FF);
