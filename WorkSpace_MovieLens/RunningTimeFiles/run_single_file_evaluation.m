function [single_results] = ...
    run_single_file_evaluation(file_name, EVA_OPT)
%run_single_file_evaluation 计算单次实验后的评价指标
%   此处显示详细说明
 
close all;
file_name
load( file_name );

% =========================================================================
[N_USER, N_ITEM, N_TIME] = size(tsntd_result.tensor);
OMEGA = test_data==0;
%%  
% ================================ TSNTD ================================
hat_ten_TSNTD = tsntd_result.tensor(:, :, 1:N_TIME);
tsntd_eva_result = cal_three_type_evaluation(hat_ten_TSNTD, test_data, OMEGA, EVA_OPT);
tsntd_eva_result.cost_time = tsntd_cost_time;

% % ================================ NTD ================================
hat_ten_NTD = ntd_result.tensor(:, :, 1:N_TIME);
ntd_eva_result = cal_three_type_evaluation(hat_ten_NTD, test_data, OMEGA, EVA_OPT);
ntd_eva_result.cost_time=  ntd_cost_time;

% ================================ RCP ================================
hat_ten_RCP = rcp_result.tensor(:, :, 1:N_TIME);
rcp_eva_result = cal_three_type_evaluation(hat_ten_RCP, test_data, OMEGA, EVA_OPT);
rcp_eva_result.cost_time = rcp_cost_time;

% ================================ UPD ================================
hat_ten_UPD = upd_result.tensor(:, :, 1:N_TIME);
upd_eva_result = cal_three_type_evaluation(hat_ten_UPD, test_data, OMEGA, EVA_OPT);
upd_eva_result.cost_time = upd_cost_time;

% ================================ SMF ================================
hat_ten_SMF = smf_result.tensor(:, :, 1:N_TIME);
smf_eva_result = cal_three_type_evaluation(hat_ten_SMF, test_data, OMEGA, EVA_OPT);
smf_eva_result.cost_time = smf_cost_time;

% ================================ MTMF ================================
hat_ten_MTMF = mtmf_result.tensor(:, :, 1:N_TIME);
mtmf_eva_result = cal_three_type_evaluation(hat_ten_MTMF, test_data, OMEGA, EVA_OPT);
mtmf_eva_result.cost_time = mtmf_cost_time;

%
single_results = [tsntd_eva_result, ntd_eva_result, rcp_eva_result,...
    upd_eva_result, smf_eva_result, mtmf_eva_result];
end

