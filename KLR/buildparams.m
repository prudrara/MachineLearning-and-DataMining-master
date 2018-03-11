function params = buildparams(maxIter, maxError, sigma)
% The parameter to the gaussian kernel
params.sigma = sigma;
% Maximum number of iterations to compute 
params.maxIter = maxIter;
% Error threshold
params.maxError = maxError;
% Step size
params.eta = @(i) 0.1 ;
end