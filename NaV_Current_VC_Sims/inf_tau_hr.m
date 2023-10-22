function[i, a, b] = inf_tau_hr(V)
i = 1/(1+exp((V+40)/28));
a =  1/(1 + exp(-(V+45)/8));
b = 0.5/(1+exp(-(V+45)/15));
end