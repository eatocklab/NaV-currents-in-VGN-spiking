function[i, t] = inf_tau_ht_BE(V)
i = 1/ (1+exp((V+65)/9));

% tau INaT inact
% from Rothman and Manis, 2003c
% t = 150*(7*exp((V+60)/13) + 10*exp(-(V+60)/12))^-1 + 0.3;

% adapted from Rothman and Manis to fit VGN current kinetics
t = 100*(7*exp((V+60)/11) + 10*exp(-(V+60)/25))^-1 + 0.6;  

%from A. Chenrayan Govindaraju, SBL's tau values fit to equations
% t = 0.0001452 * exp(-0.2211*V) + 0.2382;
end