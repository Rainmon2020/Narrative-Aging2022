% 初始化数据
cognition_label = find(cognition > 0);
macro_slicepos = macro_poslabel(1:30, :);
macro_posvalue_mean_total = mean(macro_posvalue(1:30, :), 1);
macro_rest = rest_4_mats([198, 122, 215, 88], macro_slicepos, cognition_label);
macro_rest_edge = reshape(macro_rest, [], size(macro_rest, 3));
macro_rest_edge = macro_rest_edge';
col_idx = ~any(isinf(macro_rest_edge), 1);
macro_rest_edge = macro_rest_edge(:, col_idx);
cognition = cognition(cognition_label);

% 标准化处理
X_train = macro_rest_edge;
y_train = cognition;

% 十折交叉验证
k = 10;
cv = cvpartition(length(y_train), 'KFold', k);

% R2_total = [];
% MSE_total = [];
% RMSE_total = [];
TEST_R_total = [];
TEST_P_total = [];

for i = 1:k
    % 获取训练集和测试集索引
    train_idx = cv.training(i);
    test_idx = cv.test(i);
    
    % 划分训练集和测试集
    X_train_fold = X_train(train_idx, :);
    y_train_fold = y_train(train_idx);
    X_test_fold = X_train(test_idx, :);
    y_test_fold = y_train(test_idx);
    
    % 训练线性回归模型
    mdl = fitlm(X_train_fold, y_train_fold);
    
    % 在测试集上进行预测
    y_pred = predict(mdl, X_test_fold);
    
    % 计算性能指标
%     mean_y_test = mean(y_test_fold);
%     R2 = 1 - (sum((y_pred - y_test_fold).^2) / sum((mean_y_test - y_test_fold).^2));
%     MSE = mean((y_pred - y_test_fold).^2);
%     RMSE = sqrt(MSE);
    [TEST_R, TEST_P] = corr(y_pred, y_test_fold);
    
    % 存储结果
%     R2_total = [R2_total; R2];
%     MSE_total = [MSE_total; MSE];
%     RMSE_total = [RMSE_total; RMSE];
    TEST_R_total = [TEST_R_total; TEST_R];
    TEST_P_total = [TEST_P_total; TEST_P];
end
