% Run Evaluation 

clc;
clear;
close all;
addpath(genpath('../Toolbox'))
% ========================================================================
dir_name = 'Apr-6';
files = dir(dir_name);

data_files = [];
for i = 1:length(files)
    if strfind( files(i).name, "RunningData")
        data_files = [data_files; [files(i).folder, '\', files(i).name]];
    end
end
data_files 
% ========================================================================
EVA_OPT = {};
EVA_OPT.k = [5, 10];
EVA_OPT.threshold = 1/(1+exp(-2.5)); 
[N_EXP,~] = size(data_files);   % 
N_ALG = 6;                      % TSNTD, NTD, RCP. UPD, SMF, MTMF
N_AGG_TYPE = 3;                 % MAX, MEAN, MVAVG
N_METRIC = 10;                  % RMSE, P@5, P@10, R@5, R@10, F1@5, F1@10, cost_time, frob_err

EVALUATION_SUMMARY_MAX = zeros(N_ALG, N_METRIC, N_EXP);
EVALUATION_SUMMARY_MEAN = zeros(N_ALG, N_METRIC, N_EXP);
EVALUATION_SUMMARY_MVAVG = zeros(N_ALG, N_METRIC, N_EXP);
for i = 1:N_EXP
   [single_result] = run_single_file_evaluation(data_files(i, :), EVA_OPT) ;
   for j = 1:N_ALG
        EVALUATION_SUMMARY_MAX(j, 1, i) = single_result(j).fit_max.mae;
        EVALUATION_SUMMARY_MAX(j, 2, i) = single_result(j).fit_max.rmse;
        EVALUATION_SUMMARY_MAX(j, 3, i) = single_result(j).rec_max.precision(1);
        EVALUATION_SUMMARY_MAX(j, 4, i) = single_result(j).rec_max.precision(2);
        EVALUATION_SUMMARY_MAX(j, 5, i) = single_result(j).rec_max.recall(1);
        EVALUATION_SUMMARY_MAX(j, 6, i) = single_result(j).rec_max.recall(2);
        EVALUATION_SUMMARY_MAX(j, 7, i) = single_result(j).rec_max.f1score(1);
        EVALUATION_SUMMARY_MAX(j, 8, i) = single_result(j).rec_max.f1score(2);
        EVALUATION_SUMMARY_MAX(j, 9, i) = single_result(j).cost_time;
        EVALUATION_SUMMARY_MAX(j,10, i) = single_result(j).frob_err;
   end
   for j = 1:N_ALG
        EVALUATION_SUMMARY_MEAN(j, 1, i) = single_result(j).fit_mean.mae;
        EVALUATION_SUMMARY_MEAN(j, 2, i) = single_result(j).fit_mean.rmse;
        EVALUATION_SUMMARY_MEAN(j, 3, i) = single_result(j).rec_mean.precision(1);
        EVALUATION_SUMMARY_MEAN(j, 4, i) = single_result(j).rec_mean.precision(2);
        EVALUATION_SUMMARY_MEAN(j, 5, i) = single_result(j).rec_mean.recall(1);
        EVALUATION_SUMMARY_MEAN(j, 6, i) = single_result(j).rec_mean.recall(2);
        EVALUATION_SUMMARY_MEAN(j, 7, i) = single_result(j).rec_mean.f1score(1);
        EVALUATION_SUMMARY_MEAN(j, 8, i) = single_result(j).rec_mean.f1score(2);
        EVALUATION_SUMMARY_MEAN(j, 9, i) = single_result(j).cost_time;
        EVALUATION_SUMMARY_MEAN(j,10, i) = single_result(j).frob_err;
   end
   for j = 1:N_ALG
        EVALUATION_SUMMARY_MVAVG(j, 1, i) = single_result(j).fit_mvavg.mae;
        EVALUATION_SUMMARY_MVAVG(j, 2, i) = single_result(j).fit_mvavg.rmse;
        EVALUATION_SUMMARY_MVAVG(j, 3, i) = single_result(j).rec_mvavg.precision(1);
        EVALUATION_SUMMARY_MVAVG(j, 4, i) = single_result(j).rec_mvavg.precision(2);
        EVALUATION_SUMMARY_MVAVG(j, 5, i) = single_result(j).rec_mvavg.recall(1);
        EVALUATION_SUMMARY_MVAVG(j, 6, i) = single_result(j).rec_mvavg.recall(2);
        EVALUATION_SUMMARY_MVAVG(j, 7, i) = single_result(j).rec_mvavg.f1score(1);
        EVALUATION_SUMMARY_MVAVG(j, 8, i) = single_result(j).rec_mvavg.f1score(2);
        EVALUATION_SUMMARY_MVAVG(j, 9, i) = single_result(j).cost_time;
        EVALUATION_SUMMARY_MVAVG(j,10, i) = single_result(j).frob_err;
   end
end

MEAN_rMAX = mean(EVALUATION_SUMMARY_MAX, 3);
VAR_rMAX = var(EVALUATION_SUMMARY_MAX, 0, 3);
MIN_rMAX = min(EVALUATION_SUMMARY_MAX, [], 3);
MEAN_rMEAN = mean(EVALUATION_SUMMARY_MEAN, 3);
VAR_rMEAN = var(EVALUATION_SUMMARY_MEAN, 0, 3);
MIN_rMEAN = min(EVALUATION_SUMMARY_MEAN, [],3);
MEAN_rMVAVG = mean(EVALUATION_SUMMARY_MVAVG, 3);
VAR_rMVAVG = var(EVALUATION_SUMMARY_MVAVG, 0 ,3);
MIN_rMVAVG = min(EVALUATION_SUMMARY_MVAVG, [],3);

MAX_rMAX = max(EVALUATION_SUMMARY_MAX, [], 3);
MAX_rMEAN = max(EVALUATION_SUMMARY_MEAN, [],3);
MAX_rMVAVG = max(EVALUATION_SUMMARY_MVAVG, [],3);
