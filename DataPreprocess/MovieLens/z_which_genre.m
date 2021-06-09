function genresID = z_which_genre(movieID, uniq_genre, genres_cell, movie_ids)
% =========================================================================
% 1. 提取出电影的所有体裁并保存
% 2. 根据 movieID 得到 体裁
% =========================================================================

% movies = readtable('./movies.csv',...
%                 'Delimiter',',');
% movie_ids = cell2mat(table2cell(movies(:, 1)));
% genres_cell = table2cell(movies(:,3));
% save('genres_cell', 'genres_cell');
% save('movie_ids', 'movie_ids');

% =========================================================================
% 1. 提取出电影的所有体裁并保存
% =========================================================================

% str = [];
% for i = 1:length(genres_cell)
%    str = [str, strsplit( genres_cell{i,1},'|')];
% end
% uniq_genre = unique(str);
% save('uniq_genre', 'uniq_genre')

% =========================================================================
% 2. 根据 movieID 得到 体裁
% =========================================================================

% ----- 这三个数据每次查询都加载会很慢 -----
% tic;
% load('uniq_genre.mat');
% load('genres_cell.mat');
% load('movie_ids.mat');
% disp("[z_which_genre]加载数据耗时：")
% toc

genresID = [];
index = find(movie_ids == movieID);
genre_str = genres_cell{index, 1};
genre_str = strsplit(genre_str, '|');
for j = 1:length(genre_str)
    genresID = [genresID,return_id(genre_str{j}, uniq_genre) ];
end

end

%% ================================================================
function g_id = return_id(str, uniq_genre)
    for l = 1:length(uniq_genre)
        if strcmp(str,uniq_genre{l})
            g_id = l;
            break
        end
    end
end

