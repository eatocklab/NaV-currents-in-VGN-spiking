function[i, t] = inf_tau_mt_BE(V)
i = 2/ (1 +exp(-(V+40)/8)); %2/(1+exp(-(V+40)/8)); %INaT activation

% tau INaT act
% from Rothman and Manis, 2003c
% t = (1 + exp((V+41.57)/5.733))^-1 + (1 + exp((V+8.295)/16.28))^-1 + 0.2;

% adapted from Rothman and Manis to fit current kinetics
t = 10*(5*exp((V+60)/18) + 36*exp(-(V+60)/25))^-1 + 0.04;  

%from A. Chenrayan Govindaraju, SBL's tau values fit to equations
% t = (1 + exp((V+41.57)/5.733))^-1 * (1 + exp((V+8.295)/16.28))^-1 + 0.2;
end
