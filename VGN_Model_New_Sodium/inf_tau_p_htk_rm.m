function [i t]=inf_tau_p_htk_rm(V)

i=(1+exp(-(V+23)/6))^(-1);
t=100*(4*exp((V+60)/32)+5*exp(-(V+60)/22))^(-1)+5;

end