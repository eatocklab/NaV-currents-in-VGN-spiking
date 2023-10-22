function [i t]=inf_tau_b_rm(V)

i=(1+exp((V+66)/7))^(-1/2);
t=1000*(14*exp((V+60)/27)+29*exp(-(V+60)/24))^(-1)+1;

end