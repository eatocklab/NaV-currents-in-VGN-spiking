function [II_array spikes]=spike_detection(VV)

global dt

% Calculating dV/dt
% dvdt=zeros(1,length(VV));
% for n=3:(length(VV)-3)
%     dvdt(n)=(-VV(2+n)+8*VV(1+n)-8*VV(-1+n)+VV(-2+n))/(12*dt);
% end

% ddvddt=zeros(1,length(VV));
% for n=3:(length(VV)-3)
%     ddvddt(n)=(-dvdt(2+n)+8*dvdt(1+n)-8*dvdt(-1+n)+dvdt(-2+n))/(12*dt);
% end

% sumdp=zeros(1,length(VV));
% sumdn=zeros(1,length(VV));
% for n=176:(length(VV)-176)
%     sumdpost(n)=sum(dvdt(n:n+175));
%     sumdpre(n)=sum(dvdt(n-175:n));
% end
% figure(2)
% plot(sumdpre)
% figure(3)
% plot(sumdpost)


% calculating time postion of spikes
s_count=1;
nn=400;
spikes=0;

for n=351:length(VV)-351
    if n> length(VV-3)
        break
%     elseif VV(n) > -35 && VV(n+1) < VV(n) && VV(n) > VV(n-1) && nn > 2/dt && sumdpre(n) > 3000 && sumdpost(n) < -3000
      %elseif nn > 3.5/dt && VV(n) > -35 && VV(n+1) < VV(n) && VV(n) > VV(n-1) && sum(diff(VV(n-175:n))) > 8700*dt && sum(diff(VV(n:n+175))) < -1200*dt
          elseif nn > 3.5/dt && VV(n) > 0 && VV(n+1) < VV(n) && VV(n) > VV(n-1) && sum(diff(VV(n-175:n))) > 1100*dt && sum(diff(VV(n:n+175))) < -1200*dt % nominal used for running the response maps?
          %elseif nn > 3.5/dt && VV(n) > -35 && VV(n+1) < VV(n) && VV(n) > VV(n-1) && sum(diff(VV(n-175:n))) > 500*dt && sum(diff(VV(n:n+175))) < -500*dt %detect EPSCs (green)
        %elseif nn > 3.5/dt && VV(n) > -35 && VV(n+1) < VV(n) && VV(n) > VV(n-1) && sum(diff(VV(n-175:n))) > 3000*dt && sum(diff(VV(n:n+175))) < -3000*dt %detect spikes (red)
        spikes(s_count)=n*dt;
        s_count=s_count+1;
        nn=1;        %refractory period
    end
    nn=nn+1;
end

% calculating II times
II_array=zeros(1,length(spikes)-1);
for n=1:length(spikes)-1
    II_array(n)=spikes(n+1)-spikes(n);
end


total_count=0;
for n=1:length(II_array)
    total_count=total_count+II_array(n);
    spike(n)=total_count;
end

spikes=round(spikes/dt);
spikes=round(spikes);
spikes_m50=spikes-350;
spikes_p50=spikes+350;
%close all
time=(dt:dt:length(VV)*dt);
if spikes > 0
    figure(124)
    plot(time(spikes),VV(spikes)+3,'r*')
    hold on
%     plot(spikes_m50,VV(spikes_m50),'bo')
%     plot(spikes_p50,VV(spikes_p50),'go')
    plot(time,VV)
end

% figure(1)
% plot(VV)
% figure(2)
% plot(VV,gradient(VV))
