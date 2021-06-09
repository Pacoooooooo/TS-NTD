function [single_results] = ...
    run_single_file_evaluation(file_name, EVA_OPT)
%run_single_file_evaluation 计算单次实验后的评价指标
%   此处显示详细说明
 
close all;
file_name
load( file_name );

% =========================================================================
[N_USER, N_ITEM, N_TIME] = size(tsntd_result.tensor);
MISS_FLAG = mode(train_data, 'all');
OMEGA = test_data==MISS_FLAG;
TRAIN_MISS = train_data == MISS_FLAG;
train_data(TRAIN_MISS) = 0;
%%  
% ================================ TSNTD ================================
hat_ten_TSNTD = tsntd_result.tensor(:, :, 1:N_TIME);
tsntd_eva_result = cal_three_type_evaluation(hat_ten_TSNTD, test_data, OMEGA, EVA_OPT);
tsntd_eva_result.cost_time = tsntd_cost_time;
hat_ten_TSNTD(TRAIN_MISS) = 0;
tsntd_eva_result.frob_err = frob(hat_ten_TSNTD-train_data)/frob(train_data);

% % ================================ NTD ================================
hat_ten_NTD = ntd_result.tensor(:, :, 1:N_TIME);
ntd_eva_result = cal_three_type_evaluation(hat_ten_NTD, test_data, OMEGA, EVA_OPT);
ntd_eva_result.cost_time=  ntd_cost_time;
hat_ten_NTD(TRAIN_MISS) = 0;
ntd_eva_result.frob_err = frob(hat_ten_NTD-train_data)/frob(train_data);

% ================================ RCP ================================
hat_ten_RCP = rcp_result.tensor(:, :, 1:N_TIME);
rcp_eva_result = cal_three_type_evaluation(hat_ten_RCP, test_data, OMEGA, EVA_OPT);
rcp_eva_result.cost_time = rcp_cost_time;
hat_ten_RCP(TRAIN_MISS) = 0;
rcp_eva_result.frob_err = frob(hat_ten_RCP-train_data)/frob(train_data);

% ================================ UPD ================================
hat_ten_UPD = upd_result.tensor(:, :, 1:N_TIME);
upd_eva_result = cal_three_type_evaluation(hat_ten_UPD, test_data, OMEGA, EVA_OPT);
upd_eva_result.cost_time = upd_cost_time;
hat_ten_UPD(TRAIN_MISS) = 0;
upd_eva_result.frob_err = frob(hat_ten_UPD-train_data)/frob(train_data);


% ================================ SMF ================================
hat_ten_SMF = smf_result.tensor(:, :, 1:N_TIME);
smf_eva_result = cal_three_type_evaluation(hat_ten_SMF, test_data, OMEGA, EVA_OPT);
smf_eva_result.cost_time = smf_cost_time;
hat_ten_SMF(TRAIN_MISS) = 0;
smf_eva_result.frob_err = frob(hat_ten_SMF-train_data)/frob(train_data);

% ================================ MTMF ================================
hat_ten_MTMF = mtmf_result.tensor(:, :, 1:N_TIME);
mtmf_eva_result = cal_three_type_evaluation(hat_ten_MTMF, test_data, OMEGA, EVA_OPT);
mtmf_eva_result.cost_time = mtmf_cost_time;
hat_ten_MTMF(TRAIN_MISS) = 0;
mtmf_eva_result.frob_err = frob(hat_ten_MTMF-train_data)/frob(train_data);

%
single_results = [tsntd_eva_result, ntd_eva_result, rcp_eva_result,...
    upd_eva_result, smf_eva_result, mtmf_eva_result];
end

