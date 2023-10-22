function I=I_h_rm(V)

global r_h_rm gb_h_rm Eh dt

% n=3 represents 'present' time value
n=3;

% Calculate r_infinity and r_tau (time constant) as funciton of present V
[ri tau_r]=inf_tau_r_rm(V);

% Calculate new r value using backwards difference equation
r_h_rm(n)=(2*dt*(-r_h_rm(n-1)+ri)/tau_r+4*r_h_rm(n-1)-r_h_rm(n-2))*1/3;

% Update relative time of r value
r_h_rm(n-2)=r_h_rm(n-1);
r_h_rm(n-1)=r_h_rm(n);

% Calculate current using new r value
I=gb_h_rm*r_h_rm(3)*(V-Eh);

end