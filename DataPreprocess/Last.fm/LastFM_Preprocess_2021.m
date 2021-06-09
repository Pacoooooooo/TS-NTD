% LastFM Preprocess 2021

% =========================================================================
% LastFM 2k 数据集预处理
% �? 标签记录 转化�? 类别 再转化成 频次张量
% 原数据：user-artist-tag-timesta
% 如果某个user对某个artist打过标签（即听过这首歌），记�?1�?
% =========================================================================

clc;
clear all;
close all;

%% 产生 new_lastfm_records.mat 之后就不�?要再运行这段代码
%
D = importdata('./hetrec2011-lastfm-2k/user_taggedartists-timestamps.dat')
data = D.data;

% 存在几个时间戳是负数的，把他们删�?
ts = data(:,4);
neg_index = find(ts<=0);     % 4145; 13130;  137312; 137315;  
% 删除之后的数�?
nn_data = data([1:neg_index(1)-1, ...
                neg_index(1)+1:neg_index(2)-1,...
                neg_index(2)+1:neg_index(3)-1,...
                neg_index(3)+1:neg_index(4)-1,...
                neg_index(4)+1:end],:);
% �? 170908 条数据的时间戳特别早，也删除
nn_data = nn_data([1:170907, 170909:end],:);
data = nn_data;
clear nn_data D ts neg_index;   
%}

%% 删除部分用户、物�?
%
users = data(:,1);
items = data(:,2);
tags = data(:,3);
timestamps = data(:,4);
[uniq_user, uu_ia, uu_ic] = unique(users, 'sorted');
[uniq_item, um_ia, um_ic] = unique(items, 'sorted');
uniq.user = uniq_user;
uniq.item = uniq_item;
uniq.uuic = uu_ic;
uniq.uuia = uu_ia;
uniq.umia = um_ia;
uniq.umic = um_ic;
n_genres = length( uniq_item );       

% =========================================================================

tic;
count_user = hist(users, uniq_user)';    % 1892 x 1
count_item = hist(items, uniq_item)';    % 12523 x 1
disp('统计次数耗时�?')
toc

% 
user_row_threshold = 144; 
item_row_threshold = 72;
keep_user_id = uniq_user(count_user>user_row_threshold);  % 要保留的用户id
keep_item_id = uniq_item(count_item>item_row_threshold);
keep_record_index = zeros(length(data), 1);                        % 要保留的记录下标

loop_times = length(data);
j = 1;
parfor i = 1:loop_times
    if mod(i, floor(loop_times/10)) == 0
        print_process_bar(i, loop_times);
    end
    % 通过用户id来判�?
    if ismember(users(i), keep_user_id) && ismember(items(i), keep_item_id)
        keep_record_index(i) = i; 
    end
end
keep_record_index = keep_record_index(keep_record_index>0);
[n_keep, ~] = size(keep_record_index);
fprintf("[Info] 被保留下来的记录条数: %d \n", n_keep);
new_lastfm_records = data(keep_record_index, :);
save('new_lastfm_records.mat', 'new_lastfm_records', 'keep_record_index');

%}

%% 数据记录整理成张�?
%
load('new_lastfm_records.mat')
user_id = new_lastfm_records(:,1);
item_id = new_lastfm_records(:,2);
tags = new_lastfm_records(:,3);
timestamps = new_lastfm_records(:,4);
[uniq_user, uu_ia, uu_ic] = unique(user_id, 'sorted');
[uniq_item, um_ia, um_ic] = unique(item_id, 'sorted');
uniq.user = uniq_user;
uniq.item = uniq_item;
uniq.uuic = uu_ic;
uniq.uuia = uu_ia;
uniq.umia = um_ia;
uniq.umic = um_ic;
% ------------------------------------------------------------------------
n_time_list = [3, 5, 6, 9, 12, 15, 20, 30];
f = figure;
f.Position = [50 50 1450 700];
mean_rating = zeros(max(n_time_list), length(n_time_list));
median_rating = zeros(max(n_time_list), length(n_time_list));
n_rated_in_slice = zeros(max(n_time_list), length(n_time_list));
for ttt = 1:length(n_time_list)
    n_time_slice = n_time_list(ttt);
    [edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
    n_genres = length( uniq_item );
    rating_tensor = zeros(length(uniq_user), ...
                          n_genres, ...
                          n_time_slice);           
    size(rating_tensor)
    
    tic;
    for  i = 1:length(new_lastfm_records)
%         if mod(i,1000) ==0
%             fprintf('�? %8d 条记录属�?: �? %5d 用户 | �? %5d 物品 | �? %2d 时间片\n', ...
%                     i, uu_ic(i), um_ic(i), n_t);
%         end
        % 如果和上条记录时间戳相同，略�?
        % 即，对一首歌打了多个标签也只记为�?�?
        if i > 2
            if timestamps(i) == timestamps(i-1)
                continue
            end
        end
        n_t = z_which_slice(edge, timestamps(i));
        rating_tensor(uu_ic(i), um_ic(i), n_t) = ... 
                rating_tensor(uu_ic(i), um_ic(i), n_t) + 1;

    end
    fprintf("n_time:%3d | 数据�?疏度�?%.5f\n",  n_time_slice, sum(rating_tensor==0, 'all')/numel(rating_tensor));
    toc        
    save(['lastfm_tensor_',num2str(n_time_slice)], 'rating_tensor')
    % -------------------------------------------------------------------------
    disp('[Info]�?始计算平均评�? >>>>>>>>>>>>>>>>');
    tic; 
    for i = 1:n_time_slice
        data = rating_tensor(:,:,i);
        rated_position = data > 0;
        n_rated_in_slice(i, ttt) = sum(rated_position(:)>0);
        mean_rating(i, ttt) = mean(data(rated_position));
        median_rating(i, ttt) = median(data(rated_position));
    end
    if ttt > length(n_time_list)/2
        subplot(4, length(n_time_list)/2, ttt+length(n_time_list)*0.5);
    else
        subplot(4, length(n_time_list)/2, ttt);
    end
    plot(mean_rating(:, ttt), 'o:');
    if ttt > length(n_time_list)/2
        subplot(4, length(n_time_list)/2, ttt+length(n_time_list)*1);
    else
        subplot(4, length(n_time_list)/2, ttt+length(n_time_list)*0.5);
    end
    bar(n_rated_in_slice(:, ttt))
    t5 = toc;
    fprintf("[Info]计算平均评分耗时: %.4f 秒�?�\n", t5);
end
save("split_results.mat")
%}









