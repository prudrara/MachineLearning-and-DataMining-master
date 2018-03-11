function output = dual_LR(x,y,params)

[n, ~] = size(x);

alpha_old = ones(n,1)/n;

err = 1000;
iter = 1;

% construct the kernel matrix (precomputed for speed)
K = zeros(n,n);
for i = 1:n
    for j = 1:n
        K(i,j) = kernel(x(i,:),x(j,:),params.sigma);
    end
end

while err > params.maxError && iter < params.maxIter
    exponential = exp(K * alpha_old);
    grad = (K * K * (y - (exponential ./ (1 + exponential))));
    alpha_new = alpha_old + (params.eta(iter)) * grad;
    
    % measure the error from the last iteration
    err = norm(alpha_new - alpha_old);
    % now copy the newly computed error to the previous slot
    alpha_old = alpha_new;
    
    iter = iter + 1;
    if mod(iter,100) == 0
        fprintf('Iteration: %d\n', iter);
    end
end

output.alpha = alpha_old;
output.iter = iter;
output.err = err;
output.K = K;
end