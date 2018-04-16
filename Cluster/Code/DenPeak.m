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
     
     % decision_graph ��һ��Ϊ������id�� �ڶ���Ϊ�ܶ�ֵ�������е�rho����������Ϊ�����е�deltaֵ��
     % combined_value_matrix �ڶ��е�ֵΪdecision_graph�����к͵ڶ��еĳ˻�
     decision_graph = zeros(sample_num, 4);
     combined_value_matrix = zeros(sample_num, 2);
     
     for n = 1 : sample_num
         decision_graph(n, 1) = n;
         combined_value_matrix(n, 1) = n;
         decision_graph(n, 2) = sum(distance_matrix(n, :) < dc);
     end
     
     % �����ܶ�ֵ��������
     decision_graph = sortrows(decision_graph, -2);
     
     for n = 1 : sample_num
         
         % ����ܶ���ߣ�deltaֵΪ����ֵ�е����ֵ�� ��ȷ������Ϊ��һ����������
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
     
     % �����ۺ�ָ�꣬���Դ˽�������
     combined_value_matrix(:, 2) = decision_graph(:, 2) .* decision_graph(:, 3);
     combined_value_matrix(:, 1) = decision_graph(:, 1);
     combined_value_matrix = sortrows(combined_value_matrix, -2);
     
     % ѡ��ǰk��������Ϊ��������
     centroids_index = combined_value_matrix(1:k, 1);
     for n = 1 : k
         clusterResult(centroids_index(n, 1)) = n;
     end
     
     % ���Ƴ�����ͼ
%      temp = combined_value_matrix(1:k, 1);
%      figure(1);
%      scatter(decision_graph(:, 2), decision_graph(:, 3));
%      hold on;
%      scatter(decision_graph(temp(1:k), 2), decision_graph(temp(1:k), 3), 'filled');
     
    % ÿ�����������������ܶȸ��Ҿ������������ĵ�����һ��
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