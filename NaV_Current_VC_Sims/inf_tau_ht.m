function[i, t] = inf_tau_ht(V)
i = 1/(1+exp((V+60)/9));
t = 150*(7*exp((V+60)/13) + 10*exp(-(V+60)/12))^-1 + 0.3;
end