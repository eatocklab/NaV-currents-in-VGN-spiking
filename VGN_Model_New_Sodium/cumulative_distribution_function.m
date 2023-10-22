function cdf_a=A_cumulative_distribution_function   % For II as funciton of monoexponential fit to data by Glowatski et al

global dt   

% Calculating CDF from from Amplidtude Distribution (Normal Distribution)
dt_a=.01;
cdf_a=round(cdf('norm',dt_a:dt_a:800,150,115)*1000);

% figure(7)
% plot(dt_a:dt_a:800,cdf_a)
% title('CDF amplitude distribution')