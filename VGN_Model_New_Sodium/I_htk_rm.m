function I=I_htk_rm(V)

global n_htk_rm p_htk_rm gb_htk_rm Ek dt

% n=3 represents 'present' time value
n=3;

% Calculate n & p infinity and n & p tau (time constant) as funciton of
% present V
[ni tau_n]=inf_tau_n_htk_rm(V);
[pii tau_p]=inf_tau_p_htk_rm(V);

n_htk_rm(n)=(2*dt*(-n_htk_rm(n-1)+ni)/tau_n+4*n_htk_rm(n-1)-n_htk_rm(n-2))*1/3;
p_htk_rm(n)=(2*dt*(-p_htk_rm(n-1)+pii)/tau_p+4*p_htk_rm(n-1)-p_htk_rm(n-2))*1/3;

% Update relative time of n value
n_htk_rm(n-2)=n_htk_rm(n-1);
n_htk_rm(n-1)=n_htk_rm(n);
% Update relative time of p value
p_htk_rm(n-2)=p_htk_rm(n-1);
p_htk_rm(n-1)=p_htk_rm(n);

phi=0.85;
I=gb_htk_rm*(phi*n_htk_rm(n)^2+(1-phi)*p_htk_rm(n))*(V-Ek);

end
