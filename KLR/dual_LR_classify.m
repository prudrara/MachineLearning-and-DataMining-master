function hx = dual_LR_classify(alphas, x, xtest, sigma)
    [n, ~] = size(x);
    [ntest, ~] = size(xtest);
    
    K = zeros(n,ntest);
    for i = 1:n
        for j = 1:ntest
            K(i,j) = kernel(x(i,:),xtest(j,:),sigma);
        end
    end
    
    hx = zeros(ntest,1);
    for i = 1:ntest
        e = (1/sigma)*exp(sum(alphas .* K(:,i)));
        pr_y_eq_0 = 1 / (1 + e);
        % in order to compute the output, we want when Pr(Y=1) > 0.5
        hx(i) = pr_y_eq_0 < 0.5;
    end
end