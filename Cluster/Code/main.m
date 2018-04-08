
X = load('..\Dataset\Aggregation_cluster=7.txt');
cluster_result = KMeans(X, 7, 0.05);
scatter(X(:,1), X(:,2),'filled','cdata', cluster_result);