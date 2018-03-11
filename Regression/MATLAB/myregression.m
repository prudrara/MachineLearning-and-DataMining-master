function [pred] = myregression(trainx,testx,noutputs)
%% Data
[m,n] = size(trainx);
T = trainx(:,(n - noutputs + 1):end);
trainX = trainx(:,1:(n - noutputs));
%% Transform
trainX2 = trainX.^2;
trainX3 = trainX.^3;
Phi = [ones(m,1) trainX trainX2 trainX3];
%% Regularization
I = eye(size(Phi,2));
%% Wml
Wml = [];
for lambda = -10:1:20
    Wml = [Wml ((lambda*I + (Phi'*Phi))\(Phi'*T))];
end
Ew = [];
for i = 1:noutputs:size(Wml,2)
    Ew = [Ew 0.5*sumsqr(T - (Wml(:,i:(i+noutputs-1))'*Phi')')];
end
[e,f] = min(Ew);
Wml = Wml(:,(((f-1)*noutputs) + 1):(f*noutputs));
%% Prediction
[q,~] = size(testx);
testx2 = testx.^2;
testx3 = testx.^3;
phi_test = [ones(q,1) testx testx2 testx3];
pred = Wml'*phi_test';
pred = pred';
%% Error
% for i = 1:138
% if pred(i) < 0.5
% prediction(i) = 0;
% end
% if pred(i) >= 0.5
% prediction(i) = 1;
% end
% end
% prediction = prediction';
% errors = abs(sum(ytest - prediction));