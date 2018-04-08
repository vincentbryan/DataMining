
function [clusterResult] = KMeans(X, k, errorThreshold)

    [row_num, col_num] = size(X);
    centroids = zeros(k, col_num);
    
%     随机初始化
    for n = 1 : k
        i = randperm(row_num, 1);
        centroids(n, :) =  X(i, :);
    end
    
    last_temp_cost = 0;
    temp_cluster_result = attachToCluster(X, centroids);
    temp_cost = getTotalCost(X, centroids, temp_cluster_result);
    
%     直到收敛才停止
    while(abs(temp_cost - last_temp_cost) > errorThreshold)
        centroids = updateCentroids(X, temp_cluster_result, k);
        temp_cluster_result = attachToCluster(X, centroids);
        last_temp_cost = temp_cost;
        temp_cost = getTotalCost(X, centroids, temp_cluster_result);
    end
    
    clusterResult = temp_cluster_result;
    
end

% 将各个样本点归类到离其最近的聚类中心
function [cluster_result] = attachToCluster(X, centroids)

    row_num= size(X, 1);
    cluster_result = zeros(row_num, 1);
    k = size(centroids, 1);
    
    for sample_index = 1 : row_num
       min_distance = getDistance(X(sample_index, :), centroids(1, :));
       min_index = 1;
       for centroid_index = 2 : k
           temp_distance = getDistance(X(sample_index, :), centroids(centroid_index, :));
           if temp_distance < min_distance
               min_distance = temp_distance;
               min_index = centroid_index;
           end
       end
       cluster_result(sample_index) = min_index;
    end
    
end

% 采用欧氏距离
function [distance] = getDistance(sample, centroid)
    temp = sample - centroid;
    distance = sqrt(temp * temp');
end

% 获得总的代价
function [totalCost] = getTotalCost(X, centroids, clusterResult)
    row_num = size(X, 1);
    totalCost = 0;
    for sample_index = 1 : row_num
        centroid_index = clusterResult(sample_index);
        totalCost = totalCost + getDistance(X(sample_index, :), centroids(centroid_index, :));
    end
end

% 更新聚类中心
function [centroids] = updateCentroids(X, clusterResult, k)
    [row_num, col_num] = size(X);
    acc_centroid = zeros(k, col_num);
    acc_count = zeros(k, 1);
    
    for sample_index = 1 : row_num
        centroid_index = clusterResult(sample_index);
        acc_centroid(centroid_index, :) = acc_centroid(centroid_index, :) + X(sample_index, :);
        acc_count(centroid_index) = acc_count(centroid_index) + 1;
    end
    
    centroids = acc_centroid .* repmat(1./acc_count, 1, col_num);
   
end