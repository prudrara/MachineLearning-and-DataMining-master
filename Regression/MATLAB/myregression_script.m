% script for testing myregression.m

data = load('yacht_hydrodynamics.data'); noutputs = 1;
[nr,nc] = size(data);

for cv = 1:1 % random cross validation
    cvindex = randperm(nr); % randomly permutes indices of data used for cv
    
    trainx = data(cvindex(1:floor(nr*4/5)),:);
    testx = data(cvindex(ceil(nr*4/5):end),1:end-noutputs);
    testt = data(cvindex(ceil(nr*4/5):end),end-noutputs+1:end);
    
    [pred] = myregression(trainx,testx,noutputs);
    sqerr(cv) = sum((testt(:)-pred(:)).^2);
end;
disp("Mean squareroot error:")
mean(sqerr)
% Using normalization on the data by subtracting mean and dividing by std
% dev, I get a mean squared error of around 7000 using linear regression
