function [prediction,bestk,errors] = myKNN(X,Y,Xtest,k)
% k = [1;29;50];
% load('KNNdata.mat');
Xtrain = X;
Ytrain = Y;
noutputs = 1;
data = [Xtrain Ytrain]; % data
[nr,~] = size(data);
error = zeros(nr,size(k,1));
pred = zeros(nr,size(k,1));
for cv = 1:nr, % random cross validation
    data = [Xtrain Ytrain]; % data
    testx = data(cv,1:end-noutputs);
    testt = data(cv,end-noutputs+1:end);
    data(cv,:)=[];
    trainx = data;
    for l = 1:size(k,1)
        i = l;
        for m = 1:size(trainx,1)
            D(m,:) = sqrt(sum((trainx(m,1:8) - testx) .^ 2)); % distance
        end
        [~,I] = sort(D);
        trainX = trainx(I,:);
        pred(cv,i) = mode(trainX(1:k(i),end));
        if (pred(cv,i) ~= testt)
            error(cv,i) = 1;
        end
    end
end
% % Mean error
errors = (sum(error))';
mean_error = mean(error);
[error_bestk,bestk_index] = min(mean_error);
bestk = k(bestk_index);

for o = 1:size(Xtest,1)
    for n = 1:size(Xtrain,1)
        Distance(n) = sqrt(sum((Xtrain(n,1:8) - Xtest(o,1:8)) .^ 2)); % distance
    end
    [~,Index] = sort(Distance);
    ytrain = Ytrain(Index,:);
    prediction(o,:) = mode(ytrain(1:bestk,end));
%     if (prediction(o) ~= Ytest(o))
%         error(o) = 1;
%     end
end
end
