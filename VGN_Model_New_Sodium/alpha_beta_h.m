function [a b]=alpha_beta_h(V)

a=0.07*exp(-(V+70)/20);
b=1/(exp(-(V+40)/10)+1);

end
