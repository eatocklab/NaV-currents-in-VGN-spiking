function r=rnd_spikes(x,excitation)

global dt


% % Intervent Interval Distribution
% if excitation == 40
%         t=dt:dt:200;
%         dist=129*exp(-t/15)+10*exp(-t/65);      % Interval time data from Glowatzki et al (figure 4d)
% else if excitation == 5.8
%         t=dt*7.5:dt*7.5:1500;
%         dist=exp(-t/450);
%         dist(1:2/dt)=dist(1:2/dt)*6;
%     end
% end      

tau=excitation;   % Gives the value Tau that creates a PDF of intervent invervals with a mean II equal to excitation

% t=tau/1:tau/1:tau*3;    % need to optimize this
t=dt:dt:300;          % need to optimize this
dist=exp(-t/tau);

%Calculating the CDF for ii
s=sum(dist);
for n=1:length(t)
    cdf_ii(n)=round(sum(dist(1:n))/s*1000);
end

% Calculating CDF from from Amplidtude Distribution (Normal Distribution)
dt_a=.01;
cdf_a=round(cdf('norm',dt_a:dt_a:800,150,115)*1000);
% cdf_a=cdf('norm',dt_a:dt_a:800,150,115);

% For Plotting the CDFs
figure(9)
plot(t,dist)
title('PDF intervent interval')
figure(8)
plot(t,cdf_ii)
title('CDF intervent interval distribution')
figure(7)
plot(dt_a:dt_a:800,cdf_a)
title('CDF amplitude distribution')

y=zeros(1,x./dt);
start=1;
for n=3:500 %n=1:length(y)
    r=round(rand(1)*1000);
    rr=round(rand(1)*(1000-(min(cdf_a))))+min(cdf_a);
    l=find(cdf_ii==r);
    a=find(cdf_a==rr)*dt_a;
    start=start+l(1);
    if start+l(1)>=length(y)
        break
    end
    y(start)=a(1);
end

r=y;
