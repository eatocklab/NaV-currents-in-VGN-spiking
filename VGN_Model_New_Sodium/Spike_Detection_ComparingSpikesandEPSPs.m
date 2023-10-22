load SpikeandEPSP

%V_AP=Spikes;

V_AP=VV;

[II_array_AP spikes_APEPSP]=spike_detection(V_AP)


for n=1:length(spikes_APEPSP)-1
ind_end = spikes_APEPSP(n)+350/2;
ind_beg = spikes_APEPSP(n)-350/2;
waveform = V_AP(ind_beg:ind_end);
figure(1)
twaveform = (dt:dt:length(waveform)*dt);
plot(twaveform,waveform,'r'); hold on
figure(2)
plot(waveform,gradient(waveform,twaveform),'r'); hold on
end 


[II_array_AP spikes_AP]=spike_detection_sharp(V_AP)

figure(1)
for n=1:length(spikes_AP)-1
ind_end = spikes_AP(n)+350/2;
ind_beg = spikes_AP(n)-350/2;
waveform = V_AP(ind_beg:ind_end);
figure(1)
plot(waveform,'r'); hold on
figure(2)
plot(waveform,gradient(waveform),'r'); hold on
end 




V_EPSP=EPSP;
[II_array_EPSP spikes_EPSP]=spike_detection(V_EPSP)

for n=1:length(spikes_EPSP)-1
ind_end = spikes_EPSP(n)+350/2;
ind_beg = spikes_EPSP(n)-350/2;
waveform = V_EPSP(ind_beg:ind_end);
figure(1)
plot(waveform,'g'); hold on
figure(2)
plot(waveform,gradient(waveform),'g'); hold on
end