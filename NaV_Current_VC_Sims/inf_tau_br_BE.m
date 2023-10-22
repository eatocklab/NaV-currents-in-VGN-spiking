function[i, b] = inf_tau_br_BE(V)
i = 1/(1+exp((V+40)/22));
b = 6/(1+exp(-(V-45)/8));
end