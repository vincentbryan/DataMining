
X = load('..\Dataset\Aggregation_cluster=7.txt');
% X = load('..\Dataset\flame_cluster=2.txt');
% X = load('..\Dataset\Jain_cluster=2.txt');
% X = load('..\Dataset\Pathbased_cluster=3.txt');
% X = load('..\Dataset\Spiral_cluster=3.txt');

% cluster_result = kmeans(X, 7);
% cluster_result = KMeans(X, 7, 0.05);
% cluster_result = DBSCAN(X, 5, 2.5);
% cluster_result = spectralCluster(X, 7, 6.50, 0.05, '');
cluster_result = DenPeak(X, 7, 5);
figure(2);
scatter(X(:,1), X(:,2),'filled','cdata', cluster_result);