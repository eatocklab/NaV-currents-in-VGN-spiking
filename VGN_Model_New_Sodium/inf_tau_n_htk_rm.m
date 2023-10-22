function [i t]=inf_tau_n_htk_rm(V)

i=(1+exp(-(V+15)/5))^(-1/2);
t=100*(11*exp((V+60)/24)+21*exp(-(V+60)/23))^(-1)+0.7;

end