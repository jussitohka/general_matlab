% (C) Jussi Tohka
% University of Eastern Finland, Finland
% jussi.tohka@uef.fi
% Described in
% J.D. Lewis, A.C- Evans, J. Tohka . T1 white/gray contrast as a predictor 
% of chronological age, and an index of cognitive performance. NeuroImage, 2018
function p = nihpd_permutation_test(yhat,yhat2,y,nboot)
% yhat is n of subjects x n of cv replicates matrix of predicted values
% yhat2 is the second set of predicted values
% y is the set of true values
% nboot is the number of permutations
twoside = 1;
mae1 = bsxfun(@minus,yhat,y);
mae1 = abs(mae1);  

mae2 = bsxfun(@minus,yhat2,y);
mae2 = abs(mae2);

mae = mae1 - mae2;

bsm = zeros(nboot,1);
% bsc = zeros(nboot,1);
% bsc_temp = zeros(size(yhat,2),1);
bsm(1) = mean(mean(mae));
% bsm(2) = -bsm(1);
nsubj = size(yhat,1);
nn = nsubj*size(yhat,2);
for i = 2:nboot
  %  ind = randsample(size(yhat,1),size(yhat,1),1); % sampling with replacement
  rsign = sign(2*(rand(nsubj,1) > 0.5) - 1);
  bsm(i) = sum(sum(bsxfun(@times,mae,rsign)))/nn;
   
end
p1 = (1 + sum(bsm > bsm(1)))/nboot;

if twoside 
    p2 = (1 + sum(bsm < bsm(1)))/nboot;
   %  p2 = 1 - p1; % y > x
    p = min(p1,p2)*2;
    if p2 < p1
       p = -p;
    end    
else
    p = p1;
end

