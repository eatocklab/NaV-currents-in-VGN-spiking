function [a b]=alpha_beta_n(V)

if V ~=60
    a=-0.01*(V+60)/(exp(-(V+60)/10)-1);
else
    a=0.1;
end
b=0.125*exp(-(V+70)/80);

end
