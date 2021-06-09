function [eva_result] = cal_three_type_evaluation(hat_ten, test_mat, OMEGA, EVA_OPT)
%cal_three_type_evaluation 计算三种聚合方式的效果
%   hat_ten:    
%   test_mat:
%   OMEGA:      缺失值位置
%   EVA_OPT:    
%       .k
%       .threshold
test_mat(OMEGA) = 0;
% -------------------------------------------------------------------------
type = 'MAX';
pred_max = aggregate_ratings(hat_ten, type);
pred_max(OMEGA) = 0;
[fit_max, rec_max] = evaluation(test_mat, pred_max, EVA_OPT);
% -------------------------------------------------------------------------
type = 'MEAN';
pred_mean = aggregate_ratings(hat_ten, type);
pred_mean(OMEGA) = 0;
[fit_mean, rec_mean] = evaluation(test_mat, pred_mean, EVA_OPT);
% -------------------------------------------------------------------------
type = 'MVAVG';
pred_mvavg = aggregate_ratings(hat_ten, type);
pred_mvavg(OMEGA) = 0;
[fit_mvavg, rec_mvavg] = evaluation(test_mat, pred_mvavg, EVA_OPT);

eva_result.fit_max = fit_max;
eva_result.fit_mean = fit_mean;
eva_result.fit_mvavg = fit_mvavg;
eva_result.rec_max = rec_max;
eva_result.rec_mean = rec_mean;
eva_result.rec_mvavg = rec_mvavg;


end

