function [i t]=inf_tau_a_rm(V)

i=(1+exp(-(V+31)/6))^(-1/4);
t=100*(7*exp((V+60)/14)+29*exp(-(V+60)/24))^(-1)+0.1;

end