function [INa, INaT, INaP, INaR] = INa_rm(V)
global mt ht mpinf hp br hr alphab kb gNaT gNaR gNaP ENa dt
n=2;

%Solve using Forward Euler
%Calculate m & h infinity and m & h tau (tnme constant) as function of V
%transient Na current
[mtinf, taumt] = inf_tau_mt(V); 
[htinf, tauht] = inf_tau_ht(V);

mt(n) = mt(n-1) + dt*((mtinf(n-1)-mt(n-1))/taumt);
ht(n) = ht(n-1) + dt*((htinf(n-1)-ht(n-1))/tauht);

%persistent Na current
[hpinf, tauhp] = inf_tau_hp(V);

mpinf(n) = 2/(1+exp(-(V+40)/6.4)); 
hp(n) = hp(n-1) + dt*((hpinf-hp(n-1))/tauhp);

%resurgent Na current: b = unblocking, h = inactivation
[brinf, betabr] = inf_tau_br(V);
[hrinf, alphahr, betahr] = inf_tau_hr(V);

br(n) = br(n) + dt*(alphab*(1-br(n-1))*brinf...
    - kb*betabr*br(n-1));
hr(n) = hr(n-1) + dt*(alphahr*hrinf...
    - 0.8*betahr*hr(n-1));

% update relative time of m, h, and b values
mt(n-1) = mt(n);
ht(n-1) = ht(n);
mpinf(n-1) = mpinf(n);
hp(n-1) = hp(n);
br(n-1) = br(n);
hr(n-1) = hr(n);

% calculate current components
INaT = gNaT*mt(n)^3*ht(n)*(V-ENa);
INaP = gNaP*mpinf(n)*hp(n)*(V-ENa);
INaR = gNaR*((1-br(n))^2)*(hr(n))*(V-ENa);
INa = INaT + INaP + INaR;
end