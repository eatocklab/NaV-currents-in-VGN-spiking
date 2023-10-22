function[i, t] = inf_tau_mt_rm(V)

i=(1+exp(-(V+36)/6))^(-1);
% i=(1+exp(-(V+38)/7))^(-1); %Hight and Kalluri, 2016
t=10*(5*exp((V+60)/18)+36*exp(-(V+60)/25))^(-1)+0.04;

end

