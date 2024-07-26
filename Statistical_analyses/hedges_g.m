% x1 = 1st data sample
% x2 = 2nd sample



y1 = mean(x1);
y2 = mean(x2);
n1 = length(x1);
n2 = length(x2);



sp = sqrt(((((n1 -1)*std(x1)^2)+((n2-1)*std(x2)^2))/... 
    (n1 -1)+(n2-1)));

n_tot = n1 + n2;
bias = ((n_tot-3)/(n_tot - 2.25))*(sqrt((n_tot-2)/n_tot));



g = (y1 - y2)/sp * bias;
d = (y1 - y2)/(sqrt((std(x1)^2)+(std(x2)^2)/2));