% @param X       input dataset(two dimension)
% @param MinPts  if the number of neighbors of a vertex is larger than
% MinPts, then it is considered as a core vextex
% @param eps     if the distance is larger than eps then they are considered
% neighbors
% @return        cluster result
function [clusterResult] = DBSCAN(X, MinPts, eps)
    row_num = size(X, 1);
    
    % 0 Ϊδ����
    % 1 Ϊ���ĵ�
    % 2 Ϊ�߽��
    % 3 Ϊ������
    % 4 Ϊ�����
    status = zeros(row_num, 1);
    adjacentMatrix = zeros(row_num, row_num);
    
    % ��ʼ���ڽӾ���
    for n = 1 : row_num
        for m = n : row_num
            if getDistance(X(n, :), X(m, :)) < eps
                adjacentMatrix(n, m) = 1;
                adjacentMatrix(m, n) = 1;
            end
        end
    end
    
    % ��ʼ�����ĵ�
    for n = 1 : row_num
        if sum(X(n, :)) > MinPts
            status(n) = 1;
        end
    end
    % ��ʼ���߽��
    for n = 1 : row_num
        if status(n) == 1 
            for m = 1 : row_num
                if adjacentMatrix(n, m) == 1 && status(m) == 0
                    status(m) = 2;
                end
            end
        end
    end
    % ��ʼ��������
    for n = 1 : row_num
       if status(n) == 0
           status(n) = 3;
       end
    end
    
    % ���к��ĵ��ʱ��ִ��ѭ��
    clusterResult = zeros(row_num, 1);
    centroid_id = 1;
    while( ~isempty( find(status == 1, 1) ) )
        cur_core = find(status == 1, 1);
        % ���Ϊ�����
        status(cur_core) = 4;
        clusterResult(cur_core) = centroid_id;
        
        % δ����ı��Ϊ1�� ������ı��Ϊ0
        unprocessed_core_list = zeros(row_num, 1);
        unprocessed_core_list(cur_core) = 1;
        
        while(~isempty( find(unprocessed_core_list == 1, 1)))
            cur_core = find(unprocessed_core_list == 1, 1);
            unprocessed_core_list(cur_core) = 0;
            
            for n = 1 : row_num
                if n ~= cur_core && adjacentMatrix(cur_core, n) == 1
                    clusterResult(n) = centroid_id;
                    if status(n) == 1 
                        unprocessed_core_list(n) = 1;
                    end
                    status(n) = 4;
                end
            end
        end
        
        centroid_id = centroid_id + 1;
       
    end
   
end

function [distance] = getDistance(sample1, sample2)
    temp = sample1 - sample2;
    distance = sqrt(temp * temp');
end