function[i, t] = inf_tau_ht_rm(V)

i=(1+exp((V+68)/8))^(-1);
% i=(1+exp((V+65)/6))^(-1);     %Hight and Kalluri, 2016
t=100*(7*exp((V+60)/11)+10*exp(-(V+60)/25))^(-1)+0.6;

end