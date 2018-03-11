function B = LR(x,y)
B = glmfit(x,y,'binomial','link','logit');
end