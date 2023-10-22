function[i, a, b] = inf_tau_hr_rm(V)
i = 1/(1+exp((V+40)/20)); % inactivation of resurgent sodium current
a = 1/(1+exp(-(V+45)/8));
b = 0.5/(1+exp(-(V+45)/15));
end