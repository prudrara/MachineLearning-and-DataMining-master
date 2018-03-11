function [prediction,bestlambda] = myWKNN(X,Y,Xtest)
k = 29;
Xtrain = X;
Ytrain = Y;
% load('KNNdata.mat');
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
% Weights

data = [Xtrain Ytrain]; % data
[nr,~] = size(data);
lambda = 0.0700:0.001:0.0800;
error_lambda = zeros(nr,size(lambda,2));
% pred = zeros(nr,size(lambda,2));

% k_errors = error(1:bestk,bestk_index);
k_errors = error(:,bestk_index);
pred = pred(:,bestk_index);
correct = (k_errors==0); % Correct predictions
% correct_classes = correct.*pred(1:29); % Correct classes
correct_classes = correct.*pred; % Correct classes
prediction_lambda = zeros(nr,size(lambda,2));

for cv = 1:nr, % random cross validation
    one = (correct_classes==1);
    two = (correct_classes==2);
    three = (correct_classes==3);
    
    one(cv,:) = [];
    two(cv,:) = [];
    three(cv,:) = [];
    
    data = [Xtrain Ytrain]; % data
    testx = data(cv,1:end-noutputs);
    testt = data(cv,end-noutputs+1:end);
    data(cv,:)=[];
    trainx = data;
    for i = 1:size(lambda,2)
        for m = 1:size(trainx,1)
            D(m,:) = (sum((trainx(m,1:end-noutputs) - testx) .^ 2)); % distance
            w(m,1) = exp(-lambda(i).*D(m));
        end

        prob = [];
        prob_one = (sum(one.*w))/(sum(w));
        prob_two = (sum(two.*w))/(sum(w));
        prob_three = (sum(three.*w))/(sum(w));
        prob = [prob_one prob_two prob_three];
        [max_prob, prediction_lambda(cv,i)] = max(prob);
%         pred(cv,i) = mode(trainX(1:bestk(i),end));
        if (prediction_lambda(cv,i) ~= testt)
            error_lambda(cv,i) = 1;
        end
    end
end

% best lambda = 1.2
% Mean error
errors_lambda = (sum(error_lambda));
min_error_lambda = min(errors_lambda);
mean_error_lambda = mean(error_lambda);
[error_best_lambda,best_lambda_index] = min(mean_error_lambda);
bestlambda = lambda(best_lambda_index);
%
w = zeros(size(Xtrain,1),1);
prediction = zeros(size(Xtest,1),1);
for o = 1:size(Xtest,1)
    for n = 1:size(Xtrain,1)
        Distance(n) = (sum((Xtrain(n,1:8) - Xtest(o,1:8)) .^ 2)); % distance
        w(n,1) = exp(-bestlambda*Distance(n));
    end
    
    one = (Ytrain==1);
    two = (Ytrain==2);
    three = (Ytrain==3);
    
    prob_one = (sum(one.*w))/(sum(w));
    prob_two = (sum(two.*w))/(sum(w));
    prob_three = (sum(three.*w))/(sum(w));
    prob = [prob_one prob_two prob_three];
    [~, prediction(o,1)] = max(prob);
%     if (prediction(o) ~= Ytest(o))
%         error(o) = 1;
%     end
end
end