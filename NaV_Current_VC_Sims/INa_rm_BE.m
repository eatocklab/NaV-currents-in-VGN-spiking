function [INa, INaT, INaP, INaR] = INa_rm_BE(V)
global mt ht mp mpinf hp br hr alphab kb gNaT gNaR gNaP ENa dt
n=3;

%Calculate m & h infinity and m & h tau (time constant) as function of V

% Transient Na current
[mtinf, taumt] = inf_tau_mt_BE(V); 
[htinf, tauht] = inf_tau_ht_BE(V);

% %Forward Euler Method
% mt(n) = mt(n-1) + dt*((mtinf(n-1)-mt(n-1))/taumt);
% ht(n) = ht(n-1) + dt*((htinf(n-1)-ht(n-1))/tauht);

% BE Method
mt(n) = (2*dt*(-mt(n-1)+mtinf)/taumt+4*mt(n-1)-mt(n-2))*1/3;
ht(n) = (2*dt*(-ht(n-1)+htinf)/tauht+4*ht(n-1)-ht(n-2))*1/3;

%persistent Na current
%[mpinf, taump] = inf_tau_mp_BE(V);
mpinf = inf_tau_mp_BE(V);
[hpinf, tauhp] = inf_tau_hp_BE(V);

%mp(n) = (2*dt*(-mp(n-1)+mpinf)/taump+4*mp(n-1)-mp(n-2))*1/3; 
mp(n) = mpinf;
hp(n) = (2*dt*(-hp(n-1)+hpinf)/tauhp+4*hp(n-1)-hp(n-2))*1/3;

%2/(1+exp(-(V+25)/10)); %1/(1+exp(-(V+40)/6)); 
% hp(n) = hp(n-1) + dt*((hpinf-hp(n-1))/tauhp); %FE

%resurgent Na current: b = unblocking, h = inactivation
[brinf, betabr] = inf_tau_br_BE(V);
[hrinf, alphahr, betahr] = inf_tau_hr_BE(V);

% br(n) = br(n) + dt*(alphab*(1-br(n-1))*brinf...
%     - kb*betabr*br(n-1));
% hr(n) = hr(n-1) + dt*(alphahr*hrinf...
%     - 0.8*betahr*hr(n-1));

br(n) = (2*dt*(alphab*(1-br(n-1))*brinf - kb*betabr*br(n-1))+4*br(n-1)-br(n-2))*1/3;
hr(n) = (2*dt*(alphahr*hrinf - 0.8*betahr*hr(n-1))+4*hr(n-1)-hr(n-2))*1/3;


% update relative time of m, h, and b values

mt(n-2) = mt(n-1);
mt(n-1) = mt(n);

ht(n-2) = ht(n-1);
ht(n-1) = ht(n);

mp(n-2) = mp(n-1);
mp(n-1) = mp(n);

hp(n-2) = hp(n-1);
hp(n-1) = hp(n);

br(n-2) = br(n-1);
br(n-1) = br(n);

hr(n-2) = hr(n-1);
hr(n-1) = hr(n);

% calculate current components
INaT = gNaT*mt(n)^3*ht(n)*(V-ENa);
INaP = gNaP*mp(n)*hp(n)*(V-ENa);
INaR = gNaR*((1-br(n))^3)*(hr(n)^5)*(V-ENa);
INa = INaT + INaP + INaR;
end