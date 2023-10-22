function save_trial_data(trial,temporary,V,mag_mult,excitation)

global gb_k_rm gb_na_rm gb_ltk_rm gb_htk_rm gb_h_rm gl
global Ena El Ek Eh Esyn
global dt dur spike_dur VV I_print plot_syn time spike_rate_array spike_count EPSC_shape

if trial ==1
    type='S';
else
    type='T';
end
cd(['C:\Users\baeza\OneDrive\Desktop\\Modeling\Results\EPSCsims\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)))) num2str(round(100*(mag_mult-floor(mag_mult)-1/10*(floor(10*(mag_mult-floor(mag_mult))))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','excitation','time','Ena','Ek','EPSC_shape') 
% saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)))) num2str(round(100*(mag_mult-floor(mag_mult)-1/10*(floor(10*(mag_mult-floor(mag_mult))))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_tstamp_' datestr(now,'HH_MM_AM')])
