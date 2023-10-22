
x = xlsread('VoltagesCsDen.xlsx');   % independent variables, voltage
x = x';
xcon = reshape(x',1,[]);

y = xlsread('ConductanceCsDen.xlsx');   % dependent variable, conductance
nvar = length(y(1,:));
for i = 1:nvar
    gmax = max(y(:,i));
    ynorm(:,i) = y(:,i)./gmax;
end
ycon = (reshape(ynorm, 1, []))';

%%%

% initial guess of parameters: 
p = [40 8 1 0]; 

% Boltzmann model, y = A2 - (A1 - A2)/(1+e^((x-x0)/dx)))
modelfunc = @(p, x) (p(4) - (p(3) - p(4))./(1 + exp((x - p(1))./p(2))))';  

% p(1) = x0 = V1/2
% p(2) = dx = 2
% p(3) = gmax normalized = A1
% p(4) = gmin normalized = A2

% nonlinear regression model

[beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(xcon, ycon, modelfunc, p);
mdl = nlinfit(xcon, ycon, modelfunc, p);

% plotResiduals(mdl)

% cvtree = fitrtree(x',y,'crossval','on','KFold',5);
% L = kfoldLoss(cvtree);  % mean sqaured error between observations in a fold compared to predictions

err = crossval('mse', x', y, 'Predfun', modelfunc, 'KFold',5);