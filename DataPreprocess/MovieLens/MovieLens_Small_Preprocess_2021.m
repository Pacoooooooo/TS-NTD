% MovieLens Preprocess 2021

clc;
clear;
close all;
tic
data = csvread('./ratings.csv', 1);
disp("数据加载耗时�?")
toc

n_genres = 20;
% -------------------------------------------------------------------------
timestamps = data(:, 4);
users = data(:, 1);
[uniq_user, uu_ia, uu_ic] = unique(users, 'sorted');
movies = data(:, 2);
[uniq_movie, um_ia, um_ic] = unique(movies, 'sorted');
ratings =  data(:, 3);
uniq.user = uniq_user;
uniq.movie = uniq_movie;
uniq.uuic = uu_ic;
uniq.uuia = uu_ia;
uniq.umia = um_ia;
uniq.umic = um_ic;

n_time_list = [5, 10, 20, 25, 30, 35, 40, 50];
f = figure;
f.Position = [50 50 1450 700];
mean_rating = zeros(max(n_time_list), length(n_time_list));
median_rating = zeros(max(n_time_list), length(n_time_list));
n_rated_in_slice = zeros(max(n_time_list), length(n_time_list));
tic;
load('uniq_genre.mat');
load('genres_cell.mat');
load('movie_ids.mat');
disp("[]加载数据uniq_genre, genres_cell, movie_ids耗时�?")
toc
for ttt = 1:length(n_time_list)
    n_time_slice = n_time_list(ttt);
    [edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
    rating_tensor = zeros(length(uniq_user), ...
                          n_genres, ...
                          n_time_slice);
    % size(rating_tensor)
    tic;                  
    for  i = 1:length(ratings)
        n_t = z_which_slice(edge, timestamps(i));
        n_gs = z_which_genre(movies(i), uniq_genre, genres_cell, movie_ids);
        if mod(i,1000) ==0
            fprintf('�? %8d 条记录属�?: �? %5d 用户 | �? %5d 物品 | �? %2d 时间片\n', ...
                    i, uu_ic(i), n_g(1), n_t);
        end
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        % 不要�? userID/movieID 作评分张的的index
        % 这会导致张量size远远超过应该�?要的size
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        for xxx = 1:length(n_gs)
            n_g = n_gs(xxx);
            rating_tensor(uu_ic(i), n_g, n_t) = ... 
                rating_tensor(uu_ic(i), n_g, n_t) + 1;
        end
    end
    save(['movielens_tensor_',num2str(n_time_slice)], 'rating_tensor')
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