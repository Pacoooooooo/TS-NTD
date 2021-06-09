% how to split time periods

clc;
clear;
close all;
%%
disp('[Info]开始加载数据 >>>>>>>>>>>>>>>>')
tic;
load('./new_movie_records.mat')
t = toc;
movie_records = new_movie_records;
clear new_movie_records;
fprintf('[Info]加载数据耗时: %.4f 秒。\n', t);
% -------------------------------------------------------------------------
disp('[Info]开始计算 unique >>>>>>>>>>>>>>>>')
tic;
movies = movie_records(:,1);       
users = movie_records(:, 2);      
timestamps = movie_records(:,4);     
[uniq_user, uu_ia, uu_ic] = unique(users, 'sorted');
[uniq_movie, um_ia, um_ic] = unique(movies, 'sorted');
uniq.user = uniq_user;
uniq.movie = uniq_movie;
uniq.uuic = uu_ic;
uniq.uuia = uu_ia;
uniq.umia = um_ia;
uniq.umic = um_ic;
t2 = toc;
fprintf("[Info]计算unique耗时: %.4f 秒。\n", t2);

n_time_list = [3, 5,10, 15, 20, 25, 30, 50]; % 必须偶数个
f1 = figure;
f1.Position = [50 50 1450 700];
mean_rating = zeros(max(n_time_list), length(n_time_list));
median_rating = zeros(max(n_time_list), length(n_time_list));
n_rated_in_slice = zeros(max(n_time_list), length(n_time_list));
for kk = 1:length(n_time_list)
    % -------------------------------------------------------------------------
    disp('[Info]开始划分 time periods >>>>>>>>>>>>>>>>');
    tic;
    n_time_slice = n_time_list(kk);
    [edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
    t3 = toc;
    fprintf("[Info]划分时间片耗时: %.4f 秒。\n", t3);

    % -------------------------------------------------------------------------
    disp('[Info]开始构造数据张量 >>>>>>>>>>>>>>>>');
    visit_tensor = zeros(length(uniq_user), ...
                          length(uniq_movie), ...
                          n_time_slice); 
    s = size(visit_tensor);
    fprintf("[Info] n_user: %5d, n_item: %5d, n_time: %5d", s(1), s(2), s(3));

    loop_times = length(movie_records);
    fprintf('\n====================================================================================================\n');
    for  i = 1:loop_times
        if mod(i, floor(loop_times/10)) ==0
    %         fprintf('第 %8d 条记录属于: 第 %5d 用户 | 第 %5d 物品 | 第 %2d 时间片\n', ...
    %                 i, uu_ic(i), um_ic(i), n_t);
            print_process_bar(i, loop_times);
        end
        n_t = z_which_slice(edge, timestamps(i));
    %     visit_tensor(uu_ic(i), um_ic(i), n_t) = ... 
    %             visit_tensor(uu_ic(i), um_ic(i), n_t) + 1;
        visit_tensor(uu_ic(i), um_ic(i), n_t) = movie_records(i, 3);
    end
    fprintf('\n');
    t4 = toc;
    fprintf("[Info]构造数据张量耗时: %.4f 秒。\n", t4);

    % -------------------------------------------------------------------------
    disp('[Info]开始计算平均评分 >>>>>>>>>>>>>>>>');
    tic;
    
    for i = 1:n_time_slice
        data = visit_tensor(:,:,i);
        rated_position = data > 0;
        n_rated_in_slice(i, kk) = sum(rated_position(:));
        mean_rating(i, kk) = mean(data(rated_position));
        median_rating(i, kk) = median(data(rated_position));
    end
    if kk > length(n_time_list)/2
        subplot(4, length(n_time_list)/2, kk+length(n_time_list)*0.5);
    else
        subplot(4, length(n_time_list)/2, kk);
    end
    plot(mean_rating(mean_rating(:, kk)>0, kk), 'o:');
    if kk > length(n_time_list)/2
        subplot(4, length(n_time_list)/2, kk+length(n_time_list)*1);
    else
        subplot(4, length(n_time_list)/2, kk+length(n_time_list)*0.5);
    end
    bar(n_rated_in_slice(n_rated_in_slice(:, kk)>0, kk))
    t5 = toc;
    fprintf("[Info]计算平均评分耗时: %.4f 秒。\n", t5);
end
save('split_results', 'n_rated_in_slice',  'mean_rating');

