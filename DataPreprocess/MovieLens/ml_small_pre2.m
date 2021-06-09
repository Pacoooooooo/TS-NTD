% =========================================================================
% Movielens small 数据集预处理
% 将 评分记录 转化为 类别 再转化成 频次张量
% =========================================================================

clc;
clear all;
close all;

data = csvread('./ratings.csv', 1);
n_time_slice = 44;
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


[edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
rating_tensor = zeros(length(uniq_user), ...
                      n_genres, ...
                      n_time_slice);
% size(rating_tensor)
tic;                  
for  i = 1:length(ratings)
    n_t = z_which_slice(edge, timestamps(i));
    n_gs = z_which_genre(movies(i));
    if mod(i,1000) ==0
        fprintf('第 %8d 条记录属于: 第 %5d 用户 | 第 %5d 物品 | 第 %2d 时间片\n', ...
                i, uu_ic(i), n_g(1), n_t);
    end
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % 不要用 userID/movieID 作评分张的的index
    % 这会导致张量size远远超过应该需要的size
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for xxx = 1:length(n_gs)
        n_g = n_gs(xxx);
        rating_tensor(uu_ic(i), n_g, n_t) = ... 
            rating_tensor(uu_ic(i), n_g, n_t) + 1;
    end
end
toc        
genre_tensor = rating_tensor;
clear rating_tensor;
% save('ml_small_genre','genre_tensor','uniq');
                  
                  