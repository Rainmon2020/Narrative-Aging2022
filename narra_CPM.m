all_mats  = rest_4_mats;
all_behav = cognition_total(:,5);
thresh = 0.05;

no_sub = size(all_mats,3);
no_node = size(all_mats,1);

% 将三维矩阵转化为二维矩阵，列为edge数，并且和行为进行相关
train_vcts = reshape(all_mats,[],size(all_mats,3));
[r_mat, p_mat] = corr(train_vcts', all_behav);

% 输出功能连接-行为相关矩阵，整理为NxN的格式
r_mat = reshape(r_mat,no_node,no_node);
p_mat = reshape(p_mat,no_node,no_node);

% 找出符合条件的正相关和负相关edge
pos_label = find(r_mat > 0 & p_mat < thresh);
neg_label = find(r_mat < 0 & p_mat < thresh);

[pos_row, pos_col] = find(r_mat > 0 & p_mat < thresh);
[neg_row, neg_col] = find(r_mat < 0 & p_mat < thresh);

pos_position = cat(2, pos_row, pos_col);
neg_position = cat(2, neg_row, neg_col);

% 输出符合条件的正相关和负相关edge的具体数值，并求均值
pos_edge = r_mat(pos_label);
neg_edge = r_mat(neg_label);
pos_edge_mean = mean(pos_edge);
neg_edge_mean = mean(neg_edge);

% number of iterations for permutation testing
no_iterations = 10000;

% create estimate distribution of the test statistic
% via random shuffles of data labels
new_behav = all_behav(randperm(no_sub));
null_total = corr(train_vcts', new_behav);

for it = 2:no_iterations
    fprintf('\n Performing iteration %d out of %d', it, no_iterations);
    new_behav = all_behav(randperm(no_sub));
    null_r = corr(train_vcts', new_behav);
    null_total = cat(2, null_total, null_r);
end

% 找出和与正相关edge以及负相关edge对应的零相关，计算置换10000次零相关分布的均值和标准差
null_pos = null_total(pos_label, :);
null_neg = null_total(neg_label, :);

pos_null_mean = mean(null_pos, 2);
neg_null_mean = mean(null_neg, 2);

pos_null_std = std(null_pos, 0, 2);
neg_null_std = std(null_neg, 0, 2);

% 计算所有edge零相关分布的均值和标准差
pos_null_total_mean = mean(pos_null_mean);
pos_null_total_std = std(pos_null_std);

neg_null_total_mean = mean(neg_null_mean);
neg_null_total_std = std(neg_null_std);

% 计算需要的功能连接-行为相关在零分布中的z值
z_pos = (pos_edge - pos_null_mean) ./ pos_null_std;
z_neg = (neg_edge - neg_null_mean) ./ neg_null_std;
z_total_pos = (pos_edge_mean - pos_null_total_mean) / pos_null_total_std;
z_total_neg = (neg_edge_mean - neg_null_total_mean) / neg_null_total_std;

p_pos = (1 - normcdf(abs(z_pos))) * 2;
p_neg = (1 - normcdf(abs(z_neg))) * 2;

FDR_POS = mafdr(p_pos);
FDR_NEG = mafdr(p_neg);

pos_FDR_label = find(FDR_POS < thresh);
neg_FDR_label = find(FDR_NEG < thresh);

[pos_FDR_row, pos_FDR_col] = find(FDR_POS < thresh);
[neg_FDR_row, neg_FDR_col] = find(FDR_NEG < thresh);

pos_FDR_position = pos_position(pos_FDR_label, :);
neg_FDR_position = neg_position(neg_FDR_label, :);

% 输出z值经过FDR校正的正相关和负相关edge的具体数值
pos_FDR_edge = r_mat(pos_FDR_label);
neg_FDR_edge = r_mat(neg_FDR_label);

% 十折交叉验证
k = 10;
cv = cvpartition(no_sub, 'KFold', k);

R2_total = [];
MSE_total = [];
RMSE_total = [];
TEST_R_total = [];
TEST_P_total = [];

for i = 1:k
    train_idx = cv.training(i);
    test_idx = cv.test(i);
    
    train_vcts_fold = train_vcts(:, train_idx);
    test_vcts_fold = train_vcts(:, test_idx);
    
    train_behav_fold = all_behav(train_idx);
    test_behav_fold = all_behav(test_idx);
    
    % build model on TRAIN subs
    pos_vcts_fold = train_vcts_fold(pos_label, :);
    train_pos_total_fold = pos_vcts_fold(pos_FDR_label, :);
    num_edge_pos_fold = size(train_pos_total_fold, 1);
    
    train_pos_fold = train_pos_total_fold(1, :);
    train_behav_total_fold = train_behav_fold;
    fit_total_pos_fold = polyfit(train_pos_fold', train_behav_total_fold, 1);
    
    for j = 2:num_edge_pos_fold
        train_pos_fold = train_pos_total_fold(j, :);
        fit_pos_fold = polyfit(train_pos_fold', train_behav_total_fold, 1);
        fit_total_pos_fold = cat(1, fit_total_pos_fold, fit_pos_fold);
    end
    
    % test on TEST subs
    test_pos_total_fold = pos_vcts_fold(pos_FDR_label, test_idx);
    test_behave_vcts_fold = fit_total_pos_fold(:, 1) .* test_pos_total_fold + fit_total_pos_fold(:, 2);
    test_pred_behave_fold = mean(test_behave_vcts_fold);
    
    % calculate R2, MSE, RMSE, and correlation
%     mean_test_behav_fold = mean(test_behav_fold);
%     R2_fold = 1 - (sum((test_pred_behave_fold' - test_behav_fold).^2) / sum((mean_test_behav_fold - test_behav_fold).^2));
%     MSE_fold = sum((test_pred_behave_fold' - test_behav_fold).^2) / sum(test_idx);
%     RMSE_fold = MSE_fold^0.5;
    [TEST_R_fold, TEST_P_fold] = corr(test_pred_behave_fold', test_behav_fold);
    
    % store results
%     R2_total = [R2_total; R2_fold];
%     MSE_total = [MSE_total; MSE_fold];
%     RMSE_total = [RMSE_total; RMSE_fold];
    TEST_R_total = [TEST_R_total; TEST_R_fold];
    TEST_P_total = [TEST_P_total; TEST_P_fold];
end
