clear;clc;close all;

% load HW2;
filename = 'heartstatlog_trainSet.txt';
delimiterIn = '\t';
Xtrain = importdata(filename,delimiterIn);

filename = 'heartstatlog_trainLabels.txt';
delimiterIn = '\t';
Ytrain = importdata(filename,delimiterIn);

filename = 'heartstatlog_testSet.txt';
delimiterIn = '\t';
Xtest = importdata(filename,delimiterIn);

filename = 'heartstatlog_testLabels.txt';
delimiterIn = '\t';
Ytest = importdata(filename,delimiterIn);

Ytrain(Ytrain==2)=0;
Ytest(Ytest==2)=0;

x = [Xtrain; Xtest];
y = [Ytrain; Ytest];


[n,~] = size(x);

indicies = crossvalind('Kfold',n,5);

sigmas = 0.05;
ls = length(sigmas);

trainacc = zeros(3,ls + 1);
testacc = zeros(3,ls + 1);

for i = 1:5
    itrainacc = zeros(1,ls + 1);
    itestacc = zeros(1,ls + 1);
    
    xi = x(indicies~=i,:);
    yi = y(indicies~=i);
    
    xi_test = x(indicies==i,:);
    yi_test = y(indicies==i,:);
    
    
    for s = 1:ls
        sigma = sigmas(s);
        params = buildparams(1000,1e-4,sigma);
        model = dual_LR(xi,yi,params);
        ypred_test = dual_LR_classify(model.alpha,xi,xi_test,sigma);
        ypred_train = dual_LR_classify(model.alpha,xi,xi,sigma);
        itestacc(s) = sum(ypred_test == yi_test) / length(ypred_test);
        itrainacc(s) = sum(ypred_train == yi) / length(ypred_train);
    end
    
    beta = LR(xi,yi); % already appends on bias term
    ypred_test = glmval(beta,xi_test,'logit') > 0.5;
    ypred_train = glmval(beta,xi,'logit') > 0.5;
    itestacc(ls + 1) = sum(ypred_test == yi_test) / length(ypred_test);
    itrainacc(ls + 1) = sum(ypred_train == yi) / length(ypred_train);
    
    testacc(i,:) = itestacc;
    trainacc(i,:) = itrainacc;
end