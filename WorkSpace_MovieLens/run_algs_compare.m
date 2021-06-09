clc;
% clear;
close all;
warning off;

addpath(genpath('./')) 
ts = datestr(datetime('now'));
file_name = ['Diary_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.txt'];
diary(file_name)
disp(['��ʼ��ʵ����~ ',  datestr(datetime('now')) ])
%%
data_name = './DataTensors/movielens_tensor_35.mat';
disp(['[Info]���ڼ�������:', data_name]);
tic;
load(data_name);
visit_tensor = rating_tensor;
clear rating_tensor;
load_time = toc;
fprintf("[Info]���ݼ��غ�ʱ: %.4f �롣\n", load_time);

disp(['[Info]��ʼ����Ԥ����:', data_name]);
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
% �����ݹ�һ��
FILL_NUM = 0.2;
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
    genre_tensor = genre_tensor ./ 10;
    genre_tensor = 1 ./ (1 + 1 ./ (genre_tensor));
    genre_tensor(genre_tensor==0) = FILL_NUM; 
end



% ����ѵ��/���Լ�
train_data = genre_tensor(:,:,1:34);
test_data = genre_tensor(:,:,35);
preprocess_time = toc;
fprintf("[Info]����Ԥ�����ʱ: %.4f �롣\n", preprocess_time);
clear genre_tensor;
clear visit_tensor;
%%

tic;
rank = 20;
opts = {};
opts.maxiter = 500*2;

% =========================================================================
disp('[Info]�������� TSNTD �㷨 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
gamma = 0.3;
tsntd_td = permute(train_data,[2,1,3]); %������ת�ã�ʹ֮����ģ��
tic;
SIGMA = cal_temporal_similarity(tsntd_td, gamma);
cal_temp_sim_time = toc;
fprintf("[Info][TSNTD] ����ʱ��Ƭ���ƶȺ�ʱ: %.4f �롣\n", cal_temp_sim_time);
opts.beta = 0.3;
tsntd_opts = opts;
tsntd_opts.alpha_U = 1;
tsntd_opts.alpha_L = 1;
tsntd_opts.alpha_T = 1;
tic;
tsntd_result = TSNTD(tsntd_td, rank, SIGMA, tsntd_opts);
tsntd_cost_time = toc;
tsntd_result.tensor = permute(tsntd_result.tensor, [2,1,3]); % �ָ����ݣ������������
fprintf("[Info]TSNTD �㷨��ʱ: %.4f �롣\n", tsntd_cost_time);

% =========================================================================
disp('[Info]�������� NTD �㷨 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
gamma = 1;
ntd_td = permute(train_data,[2,1,3]); %������ת�ã�ʹ֮����ģ��
tic;
SIGMA = cal_temporal_similarity(ntd_td, gamma);
cal_temp_sim_time = toc;
fprintf("[Info][NTD] ����ʱ��Ƭ���ƶȺ�ʱ: %.4f �롣\n", cal_temp_sim_time);
opts.beta = 0; % ������ʱ������
tic;
ntd_result = TSNTD(ntd_td, rank, SIGMA, opts);
ntd_cost_time = toc;
ntd_result.tensor = permute(ntd_result.tensor, [2,1,3]); % �ָ����ݣ������������
fprintf("[Info]NTD �㷨��ʱ: %.4f �롣\n", ntd_cost_time);

% =========================================================================
disp('[Info]�������� RCP �㷨 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
rcp_td = train_data;
tic;
rcp_result = RCP(rcp_td,rank, opts);
rcp_cost_time = toc;
clear rcp_td;
fprintf("[Info]RCP �㷨��ʱ: %.4f �롣\n", rcp_cost_time);

% =========================================================================
disp('[Info]�������� UPD �㷨 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
upd_td = train_data;
tic;
upd_result = UPD(upd_td, rank, opts);
clear upd_td;
upd_cost_time = toc;
fprintf("[Info]UPD �㷨��ʱ: %.4f �롣\n", upd_cost_time);

% =========================================================================
disp('[Info]�������� SMF �㷨 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
smf_td = train_data;
tic;
smf_result = SMF(smf_td, rank, opts);
clear smf_td;
smf_cost_time = toc;
fprintf("[Info]SMF �㷨��ʱ: %.4f �롣\n", smf_cost_time);

% =========================================================================
disp('[Info]�������� MTMF �㷨 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
mtmf_td = train_data;
tic;
mtmf_result = MTMF(mtmf_td, rank, opts);
clear mtmf_td;
mtmf_cost_time = toc;
fprintf("[Info]MTMF �㷨��ʱ: %.4f �롣\n", mtmf_cost_time);

%% ================================================================
diary off
ts = datestr(datetime('now'));
file_name = ['RunningData_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.mat'];
save(file_name)

