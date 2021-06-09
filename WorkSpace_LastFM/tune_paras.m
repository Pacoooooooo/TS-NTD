% tune paras
clc;
clear;
close all;
warning off;

addpath(genpath('./')) 
ts = datestr(datetime('now'));
file_name = ['TuneParaDiary_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.txt'];
diary(file_name)
disp(['开始跑实验啦~ ',  datestr(datetime('now')) ])
%%
data_name = './DataTensors/lastfm_tensor_12.mat';
disp(['[Info]正在加载数据:', data_name]);
tic;
load(data_name);
visit_tensor = rating_tensor;
clear dense_visit_tensor;
load_time = toc;
fprintf("[Info]数据加载耗时: %.4f 秒。\n", load_time);

disp(['[Info]开始数据预处理:', data_name]);
tic;
genre_tensor = visit_tensor;
[n_user, n_item, n_time] = size(visit_tensor);
clear visit_tensor;
n_select_user = n_user;
select_user_index = randperm(n_user);
n_select_item = n_item;
select_item_index = randperm(n_item);
genre_tensor = genre_tensor(select_user_index(1:n_select_user),...
                            select_item_index(1:n_select_item),...
                            :);
% 将数据归一化
FILL_NUM = 0.1;
NORM_METHOD = 'noEXPsig'; % sigmoid | rescale | noEXPsig
if contains(NORM_METHOD, 'sigmoid')
    genre_tensor = 1 ./ (1 + exp(-genre_tensor));
    genre_tensor(genre_tensor==0.5) = FILL_NUM; 
end
if contains(NORM_METHOD, 'rescale')
    genre_tensor = genre_tensor ./ 5;
    genre_tensor(genre_tensor==0) = FILL_NUM; 
end
if contains(NORM_METHOD, 'noEXPsig')
    genre_tensor = genre_tensor ./ 1;
    genre_tensor = 1 ./ (1 + 1 ./ (genre_tensor));
    genre_tensor(genre_tensor==0) = FILL_NUM; 
end



% 划分训练/测试集
train_data = genre_tensor(:,:,1:11);
test_data = genre_tensor(:,:,12);
preprocess_time = toc;
fprintf("[Info]数据预处理耗时: %.4f 秒。\n", preprocess_time);
clear genre_tensor;
clear visit_tensor;
%% Tune Rank
%{
rank_list = [3, 5, 7, 9, 11, 13, 15, 20];

for rrr = 1:length(rank_list)
    rank = rank_list(rrr);
    opts = {};
    opts.maxiter = 1000;

    % =========================================================================
    disp('[Info]正在运行 TSNTD 算法 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    gamma = 0.2;
    tsntd_td = permute(train_data,[2,1,3]); %将数据转置，使之符合模型
    tic;
    SIGMA = cal_temporal_similarity(tsntd_td, gamma);
    cal_temp_sim_time = toc;
    fprintf("[Info][TSNTD] 计算时间片相似度耗时: %.4f 秒。\n", cal_temp_sim_time);
    opts.beta = 0.5;
    tic;
    tsntd_result = TSNTD(tsntd_td, rank, SIGMA, opts);
    tsntd_cost_time = toc;
    tsntd_result.tensor = permute(tsntd_result.tensor, [2,1,3]); % 恢复数据，方便后续评价
    fprintf("[Info]TSNTD 算法耗时: %.4f 秒。\n", tsntd_cost_time);

    diary off
    ts = datestr(datetime('now'));
    file_name = ['TuneRank_', num2str(rank), '_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.mat'];
    save(file_name)
end
%}

%% Tune Gamma and beta
%{
gamma_list = [0.1, 0.3, 0.5, 0.8, 1, 2, 4, 8, 10];
beta_list = [0.1, 0.3, 0.5, 0.8, 1, 10];

for ggg = 1:length(gamma_list)
    for bbb = 1:length(beta_list)
        rank = 11;
        opts = {};
        opts.maxiter = 1000;

        % =========================================================================
        disp('[Info]正在运行 TSNTD 算法 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        gamma = gamma_list(ggg);
        tsntd_td = permute(train_data,[2,1,3]); %将数据转置，使之符合模型
        tic;
        SIGMA = cal_temporal_similarity(tsntd_td, gamma);
        cal_temp_sim_time = toc;
        fprintf("[Info][TSNTD] 计算时间片相似度耗时: %.4f 秒。\n", cal_temp_sim_time);
        opts.beta = beta_list(bbb);
        tic;
        tsntd_result = TSNTD(tsntd_td, rank, SIGMA, opts);
        tsntd_cost_time = toc;
        tsntd_result.tensor = permute(tsntd_result.tensor, [2,1,3]); % 恢复数据，方便后续评价
        fprintf("[Info]TSNTD 算法耗时: %.4f 秒。\n", tsntd_cost_time);

        diary off
        ts = datestr(datetime('now'));
        file_name = ['Tune_Gamma_', num2str(gamma), '_Beta_', num2str(opts.beta), '_',  ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.mat'];
        save(file_name)
    end
end
%}

%% Tune Alpha
%
alpha_list = [0.1, 0.3, 0.5, 0.8, 1, 10];

for rrr = 1:length(alpha_list)
    alpha = alpha_list(rrr);
    rank = 11;
    opts = {};
    opts.maxiter = 1000;

    % =========================================================================
    disp('[Info]正在运行 TSNTD 算法 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    gamma = 8;
    tsntd_td = permute(train_data,[2,1,3]); %将数据转置，使之符合模型
    tic;
    SIGMA = cal_temporal_similarity(tsntd_td, gamma);
    cal_temp_sim_time = toc;
    fprintf("[Info][TSNTD] 计算时间片相似度耗时: %.4f 秒。\n", cal_temp_sim_time);
    opts.beta = 1;
    opts.alpha_U = alpha;
    opts.alpha_L = alpha;
    opts.alpha_T = alpha;
    tic;
    tsntd_result = TSNTD(tsntd_td, rank, SIGMA, opts);
    tsntd_cost_time = toc;
    tsntd_result.tensor = permute(tsntd_result.tensor, [2,1,3]); % 恢复数据，方便后续评价
    fprintf("[Info]TSNTD 算法耗时: %.4f 秒。\n", tsntd_cost_time);

    diary off
    ts = datestr(datetime('now'));
    file_name = ['TuneAlpha_', num2str(alpha), '_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.mat'];
    save(file_name)
end
%}

%%
% BEST
% rank =  11
% gamma =  8
% beta =  1
% alpha = 0.3
