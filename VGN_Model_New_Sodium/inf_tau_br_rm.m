function[i, b] = inf_tau_br_rm(V)
i = 1/(1+exp((V+40)/22)); %unblocking of resurgent sodium current
b = 6/(1+exp(-(V-45)/8));
end