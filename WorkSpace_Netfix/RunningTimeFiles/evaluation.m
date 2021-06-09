function [fit_err, rec_acc] = evaluation(actual_matrix, predict_matrx, opt)
%EVALUATION 计算算法的评价指标
%   actual_matrix   # of users x # of itmes 
%   predict_matrx   # of users x # of itmes
%   opt:
%       .k:         top-k, default: 10
%       .threshold: like threshold, default:0.8808, i.e., [1/(1+exp(-2))]
%   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   fit_err:
%       .mae    Mean Absolute Error
%       .rmse   Root Mean Square Error
%   rec_acc:
%       .precision 
%       .recall
%       .f1score
%   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Zhehao Zhou, 2021-03-16
%   =======================================================================

% 设置参数默认值
if isfield(opt, 'k') k = opt.k; else k = [10]; end
if isfield(opt, 'threshold') threshold = opt.threshold; else threshold = 0.8808; end
    
% 计算拟合误差
[mae,rmse] = cal_fit_err(actual_matrix, predict_matrx);
fit_err.mae = mae;
fit_err.rmse = rmse;

% 计算推荐精度
actual_matrix(ismissing(actual_matrix)) = 0;
predict_matrx(ismissing(predict_matrx)) = 0;
p = zeros(length(k), 1);
r = zeros(length(k), 1);
f1 = zeros(length(k), 1);
for i = 1:length(k)
    [p(i), r(i)] = cal_rec_acc(actual_matrix, predict_matrx, k(i), threshold);
    f1(i) = 2*((p(i)*r(i)) / (p(i)+r(i)));
end
rec_acc.k = k;
rec_acc.precision = p;
rec_acc.recall = r;
rec_acc.f1score = f1;

end

function [precision, recall] = cal_rec_acc(actual_matrix, predict_matrx, k, threshold)
%     actual_matrix = 
    [n_item, n_user] = size(actual_matrix);
    user_precision = zeros(1, n_user);
    user_recall = zeros(1, n_user);
    % 将评分矩阵进行 multi-onehot 编码
    actual_matrix(actual_matrix > threshold) = 1;
    actual_matrix(actual_matrix <= threshold) = 0;
    % 计算每个用户的precision和recall
    for i = 1:n_user
        actual_user = actual_matrix(i, :);
        like_items = find(actual_user);
        predict_user = predict_matrx(i, :);
        [rating, item_id] = sort(predict_user, 'descend');
        topK_items = item_id(1:min(k, n_item));
        rec_right_item = intersect(like_items, topK_items);
        if numel(like_items) == 0
            user_precision(i) = threshold;
            user_recall(i) = threshold;
        else
            user_precision(i) = numel(rec_right_item)/k;
            user_recall(i) = numel(rec_right_item)/numel(like_items);
        end
%         fprintf("NUM_topK_items: %4d, NUM_like_items: %4d, NUM_rec_right_item: %4d \n",...
%             numel(topK_items), numel(like_items), numel(rec_right_item));
    end
    precision = mean(user_precision);
    recall = mean(user_recall);
    fprintf("[evaluation->cal_rec_err] k: %2d, P: %.4f, R: %.4f\n", k, precision, recall)
end

function [mae,rmse] = cal_fit_err(actual_matrix, predict_matrx)
%cal_fit_err 计算拟合误差

actual_matrix(ismissing(actual_matrix)) = 0;    % 将缺失值用 0  表示
miss_flag = mode(actual_matrix, 'all');         % 数据中表示“缺失”的值
omega = (actual_matrix == miss_flag);           % 未评分的位置
n_rated = numel(actual_matrix) - sum(sum(omega));   % 评分的个数

error_matrix = predict_matrx - actual_matrix;
error_matrix(omega) = 0;
fprintf('[evaluation->cal_fit_err] totol %d; omega %d; miss_ratio: %.4f\n', ...
    numel(actual_matrix), sum(sum(omega)), sum(sum(omega))/numel(actual_matrix));
mae = sum(sum(abs(error_matrix))) / n_rated;
rmse = sqrt(norm(error_matrix,'fro')^2 / n_rated);
fprintf("[evaluation->cal_fit_err] MAE: %.4f, RMSE: %.4f\n", mae, rmse);
end
