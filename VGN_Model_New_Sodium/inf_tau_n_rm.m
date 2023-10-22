function [i t]=inf_tau_n_rm(V)

[a b]=alpha_beta_n(V);
i=a/(a+b);
t=1/(a+b);
% t=50/(a+b);

end