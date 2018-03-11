function [prediction, alpha, b] = mySVM(K, Y, Kt, dataset)
% dataset = 4; % Comment after uncommenting above line.
% load('SVMdata.mat')
% if dataset == 1
%     K = K1;
%     Y = Y1;
% elseif dataset == 2
%     K = K2;
%     Y = Y2;
% elseif dataset == 3
%     K = K3;
%     Y = Y3;
% end
if (dataset == 1) || (dataset == 2) || (dataset == 3)
    [nr,~] = size(K);
    c = 0:1:10;
    C = exp(c);
    C_accuracy = zeros(size(C,2),1);
    for z = 1:size(C,2)
        cvind = zeros(10,1);
        accuracy = zeros(10,1);
        for cv = 1:10 % random cross validation
            cvindex = randi([floor(nr*0.7) floor(nr*0.8)]); % randomly permutes indices of data used for cv
            Ktrain = K((1:cvindex),1:cvindex);
            Ktest = K((1:cvindex),cvindex+1:end);
            Ytrain = Y((1:cvindex),1);
            Yt = Y((cvindex+1:end));
            cvind(cv) = cvindex;
            H = (Ytrain*Ytrain').*Ktrain;
            f = (-ones(size(Ytrain,1),1));
            Aeq = Ytrain';
            beq = 0;
            ub = C(z)*ones(size(Ytrain,1),1);
            lb = zeros(size(Ytrain,1),1);
            alpha = quadprog(H,f,[],[],Aeq,beq,lb,ub,[]);

            %
            alpha2 = (alpha>10^-3);
            alpha2 = double(alpha2);

            alpha = alpha.*alpha2;
            Ytrain = Ytrain.*alpha2;
            %
            fx = zeros(size(Ktrain,1),1);
            for i = 1:size(Ktrain,1)
                fx(i) = sum(alpha.*Ytrain.*Ktrain(i,:)');
            end
            b0 = Ytrain - alpha2.*fx;
            bp = mean(b0(Ytrain==1));
            bn = mean(b0(Ytrain==-1));
            b = mean([bp bn]);
            %
            fx_test = zeros(size(Ktest,2),1);
            for i = 1:size(Ktest,2)
                fx_test(i) = sum(alpha.*Ytrain.*Ktest(:,i)) + b;
            end
            y_test = sign(fx_test);
            error = zeros(size(Ktest,2),1);
            for i = 1:size(Yt,1)
                if y_test(i) ~= Yt(i)
                    error(i) = 1;
                end
            end
            misclassifications = sum(error);
            accuracy(cv) = ((size(Yt,1)-misclassifications)/size(Yt,1))*100;
        end
        C_accuracy(z) = mean(accuracy);
    end
    [best_accuracy,bestC_index] = max(C_accuracy);
    bestC = C(bestC_index);
elseif (dataset ~= 1) || (dataset ~= 2) || (dataset ~= 3)
    bestC = 1;
end

H = (Y*Y').*K;
f = (-ones(size(Y,1),1));
Aeq = Y';
beq = 0;
ub = bestC*ones(size(Y,1),1);
lb = zeros(size(Y,1),1);
alpha = quadprog(H,f,[],[],Aeq,beq,lb,ub,[]);
alpha2 = (alpha>10^-3);
alpha2 = double(alpha2);
alpha = alpha.*alpha2;
Y = Y.*alpha2;

fx = zeros(size(K,1),1);
for i = 1:size(K,1)
    fx(i) = sum(alpha.*Y.*K(i,:)');
end
b0 = Y - alpha2.*fx;
bp = mean(b0(Y==1));
bn = mean(b0(Y==-1));
b = mean([bp bn]);

fx_test = zeros(size(Kt,2),1);
for i = 1:size(Kt,2)
    fx_test(i) = sum(alpha.*Y.*Kt(:,i)) + b;
end
y_test = sign(fx_test);
prediction = y_test;
end