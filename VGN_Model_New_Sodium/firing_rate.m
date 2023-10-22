function [periods,FR]=firing_rate(V)

global dt dur

dv=diff(V);
s=0;
e=0;
count=1;
for n=3:length(dv)
%     if s==0 
%         if dv(n) > 0.3
%             s=n;
%         end
%     else
%         if dv(n) < 0.3
%             e=n;
%             l_M(count)=find(V(s:e) == max(V(s:e)))+s;     % location of maximum
%             count=count+1;
%             s=0;
%         end
%     end
    if s == 0
        if V(n) > -30
            
end

periods=diff(l_M)*dt;       % Period between each AP
FR=dur/length(l_M);         % Mean Firing Rate
end