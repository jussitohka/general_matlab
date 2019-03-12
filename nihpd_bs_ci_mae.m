% (C) Jussi Tohka
% University of Eastern Finland, Finland
% jussi.tohka@uef.fi
% To compute confidence intervals based on bootstrap in the repeated 
% cross-validation setting
% yhat is n x r matrix of predicted values, where n is the number os
% subjects and r is the number of CV runs
% y (n x 1) is the vector of true values
% nboot is the number of bootstrap iterations (try 1000 first)
% alpha is the alpha-level, standard choice is 0.05 producing 95% CIs
% maeci is the confidence interval for Mean absolute error (MAE)
% corrci is the confidence interaval for correlation
% Described in
% J.D. Lewis, A.C- Evans, J. Tohka . T1 white/gray contrast as a predictor 
% of chronological age, and an index of cognitive performance. NeuroImage, 2018

function [maeci corrci] = nihpd_bs_ci(yhat,y,nboot,alpha);

mae = bsxfun(@minus,yhat,y);
mae = abs(mae);  
bsm = zeros(nboot,1);
bsc = zeros(nboot,1);
bsc_temp = zeros(size(yhat,2),1);
for i = 1:nboot
   ind = randsample(size(yhat,1),size(yhat,1),1); % sampling with replacement
   bsm(i) = mean(mean(mae(ind,:)));
   for j = 1:size(yhat,2)
       bsc_tmp(j) = corr(yhat(ind,j),y(ind));
   end
   bsc(i) = mean(bsc_tmp);
end
maeci = prctile(bsm,100*[alpha/2,1 - alpha/2]);
corrci = prctile(bsc,100*[alpha/2,1 - alpha/2]);
