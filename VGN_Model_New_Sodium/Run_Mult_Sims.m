global plot_EPSC gb_na_rm gb_na_r_rm gb_na_p_rm
g_na = [12, 14, 16, 18, 20, 22];
[CV_data, spike_data] = deal(zeros(6,4));
for s = 1:5
    plot_EPSC = spikes_trains(s,:);

    for i = 1:length(g_na)
        gb_na_rm = g_na(i);

        for k = 1:4
            if k == 1
                gb_na_r_rm = 0;
                gb_na_p_rm = 0;
                Single_Compartment_Annotated(plot_EPSC, gb_na_rm, gb_na_r_rm, gb_na_p_rm)
                CV_data(i,k) = spikes.CV;
                spike_data(i,k) = spikes.spikenum;
            elseif k == 2
                gb_na_r_rm = gb_na_rm * .1;
                gb_na_p_rm = 0;

                Single_Compartment_Annotated(plot_EPSC, gb_na_rm, gb_na_r_rm, gb_na_p_rm)
                CV_data(i,k) = spikes.CV;
                spike_data(i,k) = spikes.spikenum;
            elseif k == 3
                gb_na_r_rm = 0;
                gb_na_p_rm = gb_na_rm * .03;

                Single_Compartment_Annotated(plot_EPSC, gb_na_rm, gb_na_r_rm, gb_na_p_rm)
                CV_data(i,k) = spikes.CV;
                spike_data(i,k) = spikes.spikenum;
            else
                gb_na_r_rm = gb_na_rm * .1;
                gb_na_p_rm = gb_na_rm * .03;

                Single_Compartment_Annotated(plot_EPSC, gb_na_rm, gb_na_r_rm, gb_na_p_rm)
                CV_data(i,k) = spikes.CV;
                spike_data(i,k) = spikes.spikenum;

            end
        end
    end
end



% % num_exp = 10 ;
% % [spike_count, mean_ISI, CV, spike_height] = deal(zeros(1, num_exp));
% % 
% % for i = 1:num_exp
% %     %%
% %     Single_Compartment_Annotated;
% % 
% %     Spikes_count_CV;
% %     spike_count(i) = spikes.spikenum;
% %     mean_ISI(i) = spikes.mean_ISI;
% %     CV(i) = spikes.CV;
% %     spike_height(i) = spikes.mean_spikeheight;
% % 
% % 
% % %     filename_s = (['SustainedCPR_spikes_trail_' num2str(i)]);
% % %     cd('C:\Users\baeza\OneDrive\Desktop\Modeling\Results\EPSCsims\batch0\SustainedCPR'); % Change directory for where you wish to save
% % %     save(filename_s,'spikes')
% % 
% % %     cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium'); % Change directory for where you wish to save
% % 
% % end
% % 
% % FF = var(spike_count)/mean(spike_count);
% % disp(FF);
