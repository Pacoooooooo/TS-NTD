function genresID = z_which_genre(movieID, uniq_genre, genres_cell, movie_ids)
% =========================================================================
% 1. ��ȡ����Ӱ��������ò�����
% 2. ���� movieID �õ� ���
% =========================================================================

% movies = readtable('./movies.csv',...
%                 'Delimiter',',');
% movie_ids = cell2mat(table2cell(movies(:, 1)));
% genres_cell = table2cell(movies(:,3));
% save('genres_cell', 'genres_cell');
% save('movie_ids', 'movie_ids');

% =========================================================================
% 1. ��ȡ����Ӱ��������ò�����
% =========================================================================

% str = [];
% for i = 1:length(genres_cell)
%    str = [str, strsplit( genres_cell{i,1},'|')];
% end
% uniq_genre = unique(str);
% save('uniq_genre', 'uniq_genre')

% =========================================================================
% 2. ���� movieID �õ� ���
% =========================================================================

% ----- ����������ÿ�β�ѯ�����ػ���� -----
% tic;
% load('uniq_genre.mat');
% load('genres_cell.mat');
% load('movie_ids.mat');
% disp("[z_which_genre]�������ݺ�ʱ��")
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

