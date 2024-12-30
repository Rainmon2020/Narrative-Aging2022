% 邻接矩阵表示的网络
unique_values = unique(edges);
N = numel(unique_values);
%v=ones(1,227);
%adjacency_matrix = full(sparse(edges(:,1), edges(:,2), v, N, N));
G = graph(edges(:,1),edges(:,2));
adjacency_matrix = full(adjacency(G)); % adjacency(G)返回邻接矩阵的稀疏矩阵

% 计算网络的模块度（modularity）
gamma = 1;
q = modularity_louvain_und(adjacency_matrix, gamma);

% 使用 Louvain 算法进行社区划分
[ci, q] = modularity_louvain_und(adjacency_matrix);
ci_true=ci(unique_values);
% % 使用谱聚类算法进行社区划分
% k = 4; % 需要分成的社区数量
% [S, ~, ev] = eig(adjacency_matrix, k); % 计算拉普拉斯矩阵的特征值和特征向量
% ci = kmeans(S, k); % 使用k-means算法进行聚类划分

Z = linkage(squareform(pdist(ci_true', 'jaccard')), 'ward');
% pdist计算了data中两两社区标签之间的Jaccard相似度
% squareform将pdist函数返回的向量转化为N x N的矩阵
% linkage函数进行层次聚类，使用Ward's method作为距离衡量指标
k = 4;
T = cluster(Z, 'maxclust', k);
% cluster函数将层次聚类结果划分为K个簇
community=cat(2,T,unique_values)

%%%计算每个社区富集到的
%macro_node_degeree:gephi导出的node表格id和degree两列
%macro_edge:导出的edge表格,source和target

%% % 构建相似度矩阵
for i=1:400
    Nonlinear(i,i)=0
end

similarity_matrix = abs(Nonlinear);

% 构建图数据结构
graph = graph(similarity_matrix);

% 使用谱聚类算法进行社区划分
num_clusters = 5; % 设置要划分的社区数量
membership = spectralcluster(graph, num_clusters); 

% 显示社区划分结果
disp(membership);

%% 

source~=2;

DMN_num=91;
DMN_net1=find(community(:,1)==source & community(:,2)>=68 & community(:,2)<=119);
DMN_net2=find(community(:,1)==source & community(:,2)>=198 & community(:,2)<=236);
DMN_net=cat(1,DMN_net1,DMN_net2);


DAN_num=46;
DAN_net1=find(community(:,1)==source & community(:,2)>=1 & community(:,2)<=23);
DAN_net2=find(community(:,1)==source & community(:,2)>=120 & community(:,2)<=142);
DAN_net=cat(1,DAN_net1,DAN_net2);

VAN_num=47;
VAN_net1=find(community(:,1)==source & community(:,2)>=24 & community(:,2)<=45);
VAN_net2=find(community(:,1)==source & community(:,2)>=143 & community(:,2)<=167);
VAN_net=cat(1,VAN_net1,VAN_net2);

CON_num=52;
CON_net1=find(community(:,1)==source & community(:,2)>=46 & community(:,2)<=67);
CON_net2=find(community(:,1)==source & community(:,2)>=168 & community(:,2)<=197);
CON_net=cat(1,CON_net1,CON_net2);


DMN_Ai=size(DMN_net,1);
DAN_Ai=size(DAN_net,1);
VAN_Ai=size(VAN_net,1);
CON_Ai=size(CON_net,1);
Ai_all=DMN_Ai+DAN_Ai+VAN_Ai+CON_Ai

DMN_Ei=Ai_all*DMN_num/235;
DMN_Enrich=DMN_Ai/DMN_Ei;

DAN_Ei=Ai_all*DAN_num/235;
DAN_Enrich=DAN_Ai/DAN_Ei;

VAN_Ei=Ai_all*VAN_num/235;
VAN_Enrich=VAN_Ai/VAN_Ei;

CON_Ei=Ai_all*CON_num/235;
CON_Enrich=CON_Ai/CON_Ei;







%%%%%%%%%% 利用permutation test计算不同社区enrich到的网络的显著性 %%%%%%%

no_iterations=10000;
new_node=unique_values(randperm(N));
new_community=cat(2,T,new_node);

%%
source~=2;
DMN_num=91;
DMN_net1=find(new_community(:,1)==source & new_community(:,2)>=68 & new_community(:,2)<=119);
DMN_net2=find(new_community(:,1)==source & new_community(:,2)>=198 & new_community(:,2)<=236);
DMN_net=cat(1,DMN_net1,DMN_net2);


DAN_num=46;
DAN_net1=find(new_community(:,1)==source & new_community(:,2)>=1 & new_community(:,2)<=23);
DAN_net2=find(new_community(:,1)==source & new_community(:,2)>=120 & new_community(:,2)<=142);
DAN_net=cat(1,DAN_net1,DAN_net2);

VAN_num=47;
VAN_net1=find(new_community(:,1)==source & new_community(:,2)>=24 & new_community(:,2)<=45);
VAN_net2=find(new_community(:,1)==source & new_community(:,2)>=143 & new_community(:,2)<=167);
VAN_net=cat(1,VAN_net1,VAN_net2);

CON_num=52;
CON_net1=find(new_community(:,1)==source & new_community(:,2)>=46 & new_community(:,2)<=67);
CON_net2=find(new_community(:,1)==source & new_community(:,2)>=168 & new_community(:,2)<=197);
CON_net=cat(1,CON_net1,CON_net2);


DMN_Ai=size(DMN_net,1);
DAN_Ai=size(DAN_net,1);
VAN_Ai=size(VAN_net,1);
CON_Ai=size(CON_net,1);
Ai_all=DMN_Ai+DAN_Ai+VAN_Ai+CON_Ai

DMN_Ei=Ai_all*DMN_num/235;
DMN_Enrich_total=DMN_Ai/DMN_Ei;

DAN_Ei=Ai_all*DAN_num/235;
DAN_Enrich_total=DAN_Ai/DAN_Ei;

VAN_Ei=Ai_all*VAN_num/235;
VAN_Enrich_total=VAN_Ai/VAN_Ei;

CON_Ei=Ai_all*CON_num/235;
CON_Enrich_total=CON_Ai/CON_Ei;

%%

%接下来的permutation循环，输出零相关矩阵
for it=2:no_iterations
    fprintf('\n Performing iteration %d out of %d', it, no_iterations);
    new_node=unique_values(randperm(N));
    new_community=cat(2,T,new_node);

    DMN_net1=find(new_community(:,1)==source & new_community(:,2)>=68 & new_community(:,2)<=119);
    DMN_net2=find(new_community(:,1)==source & new_community(:,2)>=198 & new_community(:,2)<=236);
    DMN_net=cat(1,DMN_net1,DMN_net2);

    DAN_net1=find(new_community(:,1)==source & new_community(:,2)>=1 & new_community(:,2)<=23);
    DAN_net2=find(new_community(:,1)==source & new_community(:,2)>=120 & new_community(:,2)<=142);
    DAN_net=cat(1,DAN_net1,DAN_net2);

    VAN_net1=find(new_community(:,1)==source & new_community(:,2)>=24 & new_community(:,2)<=45);
    VAN_net2=find(new_community(:,1)==source & new_community(:,2)>=143 & new_community(:,2)<=167);
    VAN_net=cat(1,VAN_net1,VAN_net2);

    CON_net1=find(new_community(:,1)==source & new_community(:,2)>=46 & new_community(:,2)<=67);
    CON_net2=find(new_community(:,1)==source & new_community(:,2)>=168 & new_community(:,2)<=197);
    CON_net=cat(1,CON_net1,CON_net2);
    
    DMN_Ai=size(DMN_net,1);
    DAN_Ai=size(DAN_net,1);
    VAN_Ai=size(VAN_net,1);
    CON_Ai=size(CON_net,1);
    Ai_all=DMN_Ai+DAN_Ai+VAN_Ai+CON_Ai
    
    DMN_Ei=Ai_all*DMN_num/235;
    DMN_Enrich_null=DMN_Ai/DMN_Ei;
    DMN_Enrich_total=cat(2,DMN_Enrich_total,DMN_Enrich_null); 

    DAN_Ei=Ai_all*DAN_num/235;
    DAN_Enrich_null=DAN_Ai/DAN_Ei;
    DAN_Enrich_total=cat(2,DAN_Enrich_total,DAN_Enrich_null); 

    VAN_Ei=Ai_all*VAN_num/235;
    VAN_Enrich_null=VAN_Ai/VAN_Ei;
    VAN_Enrich_total=cat(2,VAN_Enrich_total,VAN_Enrich_null); 

    CON_Ei=Ai_all*CON_num/235;
    CON_Enrich_null=CON_Ai/CON_Ei;
    CON_Enrich_total=cat(2,CON_Enrich_total,CON_Enrich_null); 
end

%计算显著性
n_dmn=find(DMN_Enrich_total>DMN_Enrich);
p_dmn=size(n_dmn,2)/no_iterations;

n_dan=find(DAN_Enrich_total>DAN_Enrich);
p_dan=size(n_dan,2)/no_iterations;

n_van=find(VAN_Enrich_total>VAN_Enrich);
p_van=size(n_van,2)/no_iterations;

n_con=find(CON_Enrich_total>CON_Enrich);
p_con=size(n_con,2)/no_iterations;




