% run evaluation
%

clc;
clear;
close all;

%% ==============================================================
dir_name = 'Mar-30';
file_name = 'RunningData_30-Mar-2021_111936.mat';
load(['./', dir_name, '/', file_name]);

[N_USER, N_ITEM, N_TIME] = size(tsntd_result.tensor);
EVA_OPT = {};
EVA_OPT.k = [5, 10];
EVA_OPT.threshold = 1/(1+exp(-2.5));
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

