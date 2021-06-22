function [mdist, q, p] = DTW(T,R)

% [mdist, q, p] = DTW(T,R)
% 
% This function finds the lowest distance between matrixes T and R
% according to DTW.
% T         - testing matrix
% R         - reference matrix
% mdist     - distance
% q         - path related to matrix T
% p         - path related to matrix R

%% Compute the distance matrix
[c1, r1] = size(T);
[c2, r2] = size(R);
dist_mat = zeros(r2,r1);

for n=1:r1    
    cl = T(:,n);
    wm = cl(:,ones(1,r2));
    rm = wm - R;
    pm = rm.^2;
    dist_mat(:,n) = sqrt(sum(pm).');
end

%% This finds distance matrix using *.mex file
% dist_mat = locdist(T, R);

%% Find the path and minimum cost
[p, q, D, sc] = dpfast(dist_mat);
mdist = D(end,end)./(r1+r2);