function[i, b] = inf_tau_br(V)
i = 1/(1+exp((V+40)/22));
b = 2/(1+exp(-(V-45)/8));
end