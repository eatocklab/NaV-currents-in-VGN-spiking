function I=I_k_rm(V)

global a_k_rm b_k_rm c_k_rm gb_k_rm Ek dt

% n=3 represents 'present' time value
n=3;

% Calculate a, b, & c infinity and a, b, & c tau (time constant) as
% funciton of present V
[ai tau_a]=inf_tau_a_rm(V);
[bi tau_b]=inf_tau_b_rm(V);
[ci tau_c]=inf_tau_c_rm(V);

a_k_rm(n)=(2*dt*(-a_k_rm(n-1)+ai)/tau_a+4*a_k_rm(n-1)-a_k_rm(n-2))*1/3;
b_k_rm(n)=(2*dt*(-b_k_rm(n-1)+bi)/tau_b+4*b_k_rm(n-1)-b_k_rm(n-2))*1/3; 
c_k_rm(n)=(2*dt*(-c_k_rm(n-1)+ci)/tau_c+4*c_k_rm(n-1)-c_k_rm(n-2))*1/3;

% Update relative time of a value
a_k_rm(n-2)=a_k_rm(n-1);
a_k_rm(n-1)=a_k_rm(n);
% Update relative time of b value
b_k_rm(n-2)=b_k_rm(n-1);
b_k_rm(n-1)=b_k_rm(n);
% Update relative time of c value
c_k_rm(n-2)=c_k_rm(n-1);
c_k_rm(n-1)=c_k_rm(n);


I=gb_k_rm*a_k_rm(n)^4*b_k_rm(n)*c_k_rm(n)*(V-Ek);

end