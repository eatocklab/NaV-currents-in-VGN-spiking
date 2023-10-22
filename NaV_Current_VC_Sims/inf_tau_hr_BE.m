function[i, a, b] = inf_tau_hr_BE(V)
i = 1/(1 + exp((V+40)/20));
a = 1/(1 + exp(-(V+45)/8));
b = 0.5/(1+exp(-(V+45)/15));
end