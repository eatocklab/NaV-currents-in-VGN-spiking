function [a b]=alpha_beta_m(V)

if V ~=45
    a=-0.1*(V+45)/(exp(-(V+45)/10)-1);  % ms
else
    a=1;                                % ms
end
b=4*exp(-(V+70)/18);                    % ms

end