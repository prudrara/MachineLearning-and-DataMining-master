function k = kernel(x, y, sigma)
% Gaussian kernel parameters

% inner = - norm(x-y)^2 / (2 * sigma * sigma); 
inner = - norm(x-y) / (2 * sigma * sigma);
% inner = (x*y' + 1).^2;
% inner = (x*y' + 1);
k = exp(inner);
% k = inner;
end