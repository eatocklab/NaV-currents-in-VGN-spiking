function[i, t] = inf_tau_hp(V)
i = 1/(1+exp((V+52)/14));
t = 100 + (500/(1+exp((V+60)/10)));
end