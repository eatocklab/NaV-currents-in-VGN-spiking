function [i t]=inf_tau_w_ltk_rm(V)

i=(1+exp(-(V+44.5)/8.4))^(-1/4);
t=100*(6*exp((V+60)/6)+16*exp(-(V+60)/45))^(-1)+1.5; %IKL %Change back to 100 for kv1 like

%t=1000*(6*exp((V+60)/6)+16*exp(-(V+60)/45))^(-1)+1.5; %I_KCNQ

end