function[i,t] = inf_hp_rm(V)
i = 1/(1+exp((V+52)/14)); % Persistent sodium current inactivation
t = 100 + (10000/(1+exp((V+60)/10))); % tau of inact
end