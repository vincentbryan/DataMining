
X = load('..\Dataset\Aggregation_cluster=7.txt');
% X = load('..\Dataset\flame_cluster=2.txt');
% X = load('..\Dataset\Jain_cluster=2.txt');
% X = load('..\Dataset\Pathbased_cluster=3.txt');
% X = load('..\Dataset\Spiral_cluster=3.txt');

% cluster_result = KMeans(X, 7, 0.05);
cluster_result = DBSCAN(X, 5, 2.5);
scatter(X(:,1), X(:,2),'filled','cdata', cluster_result);