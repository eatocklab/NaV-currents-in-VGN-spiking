function [Spikes] = spike_CV(V,Time,threshold)
   
    [pks,locs]=findpeaks(V(1:10000),'minpeakheight',threshold);
    Spikes.spikeheight=pks;
    Spikes.mean_spikeheight = mean(Spikes.spikeheight);
%     Spikes.sem_spikeheight = std(Spikes.spikeheight)/sqrt(length(Spikes.spikeheight));

    %     Spikes.s_time = Time(locs);
    
    Spikes.spikenum =numel(findpeaks(V,'minpeakheight',threshold));
%     Spikes.sem_spikenum = std(Spikes.spikenum)/sqrt(length(Spikes.spikenum));
%     Spikes.var_spikenum = var(Spikes.spikenum);
    
    Spikes.ISI=diff(Time(locs));
    Spikes.mean_ISI = mean(Spikes.ISI);
%     Spikes.sem_ISI = std(Spikes.ISI)/sqrt(length(Spikes.ISI));
    
    Spikes.CV= std(Spikes.ISI)/mean(Spikes.ISI);
%     Spikes.FF = var(Spikes.spikenum)/mean(Spikes.spikenum);
end

     