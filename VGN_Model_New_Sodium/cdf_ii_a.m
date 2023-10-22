function [cdf_ii cdf_a]=cdf_ii_a(excitation)   % For II as funciton of monoexponential fit to data by Glowatski et al

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

% Calculating CDF from from Amplidtude Distribution (Normal Distribution)
dt_a=.01;
cdf_a=round(cdf('norm',dt_a:dt_a:800,150,115)*1000);

% % For Plotting the CDFs
% figure(9)
% plot(t,dist)
% title('PDF intervent interval')
% figure(8)
% plot(t,cdf_ii)
% title('CDF intervent interval distribution')
% figure(7)
% plot(dt_a:dt_a:800,cdf_a)
% title('CDF amplitude distribution')



r=round(rand(1)*1000);
rr=round(rand(1)*(1000-(min(cdf_a))))+min(cdf_a);
ii=find(cdf_ii==r);
exists_var = exist('ii','var');
if ii > 0
    
else
    for n=1:length(t)
        if r < cdf_ii(n)
            ii=n;
            break
        end
    end
end
a=find(cdf_a==rr)*dt_a;

II=ii(1);
A=a(1);


