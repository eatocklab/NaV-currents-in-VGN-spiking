function[i, t] = inf_tau_hp_BE(V)
i = 1/(1+exp((V+52)/14));
t = 100 + (10000/(1+exp((V+60)/10)));
end