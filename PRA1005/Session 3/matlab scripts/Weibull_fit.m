function err = Weibull_fit(pars,x,data)
t=pars(1); %% threshold
b=pars(2); %% slope
g=pars(3); %% False alarm rate
e = .75;%%;

k = (-log( (1-e)/(1-g)))^(1/b);
y = 1- (1-g)*exp(- (k*x/t).^b);

err=sum((data-y).^2);