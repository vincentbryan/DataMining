% @param X    input data
% @param k    number of clusters
% @param eps  if the distance is larger than eps then they are considered
% adjacent
% @return     cluster result
function [clusterResult] = spectralCluster(X, k, eps, kmeansThrehold, stringValue)

    sample_num = size(X, 1);    
    
% 构建W矩阵(邻接矩阵)    
    W = zeros(sample_num, sample_num);
    for n = 1 : sample_num
        for m = n+1 : sample_num
            if getDistance(X(n, :), X(m,:)) < eps
                W(n, m) = 1;
                W(m, n) = 1;
            end
        end
    end
    
% 构建D矩阵(度数矩阵)
    D = zeros(sample_num, sample_num);
    for n = 1 : sample_num
        D(n, n) = sum(W(n, :));
    end
    
% 构建L矩阵(拉普拉斯矩阵)
    
    
    if strcmp(stringValue, 'RCut')
        L = D - W;
    else
        for n = 1 : sample_num
            for m = 1 : sample_num
                if D(n, m) ~= 0
                    D(n, m) = D(n, m)^(-.5);
                end
            end
        end
        L = eye(sample_num) - D * W * D;
    end
    
    [eigenvectors, eigenvalues] = eigs(L, k, 'SA');
    
    clusterResult = KMeans(eigenvectors, k, kmeansThrehold);
%     clusterResult = kmeans(eigenvectors, k);
end

function [distance] = getDistance(sample1, sample2)
    temp = sample1 - sample2;
    distance = sqrt(temp * temp');
end