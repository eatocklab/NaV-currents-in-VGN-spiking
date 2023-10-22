function cdf_ii=II_cumulative_distribution_function(excitation)   % For II as funciton of monoexponential fit to data by Glowatski et al

global dt   

tau=excitation;   % Gives the value Tau that creates a PDF of intervent invervals with a mean II equal to excitation

% t=tau/1:tau/1:tau*3;    % need to optimize this
t=dt:dt:9.5*tau;          % need to optimize this
dist=exp(-t/tau);

%Calculating the CDF for ii
s=sum(dist);
for n=1:length(t)
    cdf_ii(n)=round(sum(dist(1:n))/s*1000);
end

% % For Plotting the CDFs
% figure(9)
% plot(t,dist)
% title('PDF intervent interval')
% figure(8)
% plot(t,cdf_ii)
% title('CDF intervent interval distribution')
% figure(7)



