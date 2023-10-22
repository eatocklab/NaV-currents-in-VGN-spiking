function[i, t] = inf_tau_mt(V)
i = 1/(1+exp(-(V+36)/6)); %INaT activation
t = 10*(5*exp((V+60)/18) + 30*exp(-(V+60)/12))^-1 + 0.08; % tau INaT act
end
