function [i t]=inf_tau_c_rm(V)

i=(1+exp((V+66)/7))^(-1/2);
t=90*(1+exp(-(V+66)/17))^(-1)+10;

end