function [i t]=inf_tau_z_ltk_rm(V)

zeta = 0.5; % partial inactivation (KV1)
i=(1-zeta)*(1+exp((V+71)/10))^(-1)+zeta;
t=1000*(exp((V+60)/20)+exp(-(V+60)/8))^(-1)+50; %IKL

% zeta=1; %no inactivation (IKCNQ)
% i=(1-zeta)*(1+exp((V+71)/10))^(-1)+zeta;
% t=10000*(exp((V+60)/20)+exp(-(V+60)/8))^(-1)+50; %IKL

% zeta = 0; %complete inactivation (IA)
% i=(1-zeta)*(1+exp((V+71)/10))^(-1)+zeta;
% t=10*(exp((V+60)/20)+exp(-(V+60)/8))^(-1)+50; %IA
end 