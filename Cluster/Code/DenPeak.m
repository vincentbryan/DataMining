% @param X    input data
% @param dc   if the distance is larger than dc then they are considered
% adjacent
% @return     cluster result
function [clusterResult] = DenPeak(X, k, dc)

     sample_num = size(X, 1);
     distance_matrix = zeros(sample_num, sample_num);
     clusterResult = zeros(sample_num, 1);
     
     for n = 1 :sample_num
         for m = n+1 : sample_num
             distance_matrix(n, m) = getDistance(X(n, :), X(m, :));
             distance_matrix(m, n) = distance_matrix(n, m);
         end
     end
     
     % decision_graph 第一列为样本的id， 第二列为密度值（论文中的rho），第三列为论文中的delta值，
     % combined_value_matrix 第二列的值为decision_graph第三列和第二列的乘积
     decision_graph = zeros(sample_num, 4);
     combined_value_matrix = zeros(sample_num, 2);
     
     for n = 1 : sample_num
         decision_graph(n, 1) = n;
         combined_value_matrix(n, 1) = n;
         decision_graph(n, 2) = sum(distance_matrix(n, :) < dc);
     end
     
     % 按照密度值降序排列
     decision_graph = sortrows(decision_graph, -2);
     
     for n = 1 : sample_num
         
         % 如果密度最高，delta值为距离值中的最大值， 以确保其作为第一个聚类中心
         if n == 1 
             max_dist = max(distance_matrix(decision_graph(n, 1), :));
             decision_graph(n, 3) = max_dist;
             continue;
         end
         
         min_dist = distance_matrix(decision_graph(n, 1), decision_graph(1, 1));
         for m = 2 : n-1
             temp_dist = distance_matrix(decision_graph(n, 1), decision_graph(m, 1));
             if temp_dist < min_dist
                 min_dist = temp_dist;
             end
         end
         
         decision_graph(n, 3) = min_dist;
     end
     
     % 计算综合指标，并以此降序排列
     combined_value_matrix(:, 2) = decision_graph(:, 2) .* decision_graph(:, 3);
     combined_value_matrix(:, 1) = decision_graph(:, 1);
     combined_value_matrix = sortrows(combined_value_matrix, -2);
     
     % 选择前k个样本作为聚类中心
     centroids_index = combined_value_matrix(1:k, 1);
     for n = 1 : k
         clusterResult(centroids_index(n, 1)) = n;
     end
     
     % 绘制出决策图
%      temp = combined_value_matrix(1:k, 1);
%      figure(1);
%      scatter(decision_graph(:, 2), decision_graph(:, 3));
%      hold on;
%      scatter(decision_graph(temp(1:k), 2), decision_graph(temp(1:k), 3), 'filled');
     
    % 每个点的类别，与比这个点密度高且距离这个点最近的点的类别一样
     for n = 1 : sample_num
         cur_index = decision_graph(n, 1);
         if clusterResult(cur_index) ~= 0
             continue;
         end
         index = 1;
         min_dist = distance_matrix(cur_index, decision_graph(1, 1));
         for m = 2 : n-1
             temp_dist = distance_matrix(cur_index, decision_graph(m, 1));
             if temp_dist < min_dist
                 min_dist = temp_dist;
                 index = m;
             end
         end
         
         clusterResult(cur_index) = clusterResult(decision_graph(index, 1));
     end
     
end

function [distance] = getDistance(sample1, sample2)
    temp = sample1 - sample2;
    distance = sqrt(temp * temp');
end