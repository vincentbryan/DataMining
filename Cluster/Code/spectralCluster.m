% @param X    input data
% @param k    number of clusters
% @param eps  if the distance is larger than eps then they are considered
% adjacent
% @return     cluster result
function [clusterResult] = spectralCluster(X, k, eps, kmeansThrehold, stringValue)

    sample_num = size(X, 1);    
    
% ����W����(�ڽӾ���)    
    W = zeros(sample_num, sample_num);
    for n = 1 : sample_num
        for m = n+1 : sample_num
            if getDistance(X(n, :), X(m,:)) < eps
                W(n, m) = 1;
                W(m, n) = 1;
            end
        end
    end
    
% ����D����(��������)
    D = zeros(sample_num, sample_num);
    for n = 1 : sample_num
        D(n, n) = sum(W(n, :));
    end
    
% ����L����(������˹����)
    
    
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