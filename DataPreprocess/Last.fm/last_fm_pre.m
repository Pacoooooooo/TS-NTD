% =========================================================================
% LastFM 2k ���ݼ�Ԥ����
% �� ��ǩ��¼ ת��Ϊ ��� ��ת���� Ƶ������
% ԭ���ݣ�user-artist-tag-timesta
% ���ĳ��user��ĳ��artist�����ǩ�����������׸裩����Ϊ1��
% =========================================================================

clc;
clear all;
close all;

D = importdata('./hetrec2011-lastfm-2k/user_taggedartists-timestamps.dat')
data = D.data;

% ���ڼ���ʱ����Ǹ����ģ�������ɾ��
ts = data(:,4);
neg_index = find(ts<=0);     % 4145; 13130;  137312; 137315;  
% ɾ��֮�������
nn_data = data([1:neg_index(1)-1, ...
                neg_index(1)+1:neg_index(2)-1,...
                neg_index(2)+1:neg_index(3)-1,...
                neg_index(3)+1:neg_index(4)-1,...
                neg_index(4)+1:end],:);
% �� 170908 �����ݵ�ʱ����ر��磬Ҳɾ��
nn_data = nn_data([1:170907, 170909:end],:);
data = nn_data;
clear nn_data D ts neg_index;         
%%
% Ϊ�˷������֮ǰ�Ĵ��룬
% ���´���� movie ���� artist

users = data(:,1);
movies = data(:,2);
tags = data(:,3);
timestamps = data(:,4);
[uniq_user, uu_ia, uu_ic] = unique(users, 'sorted');
[uniq_movie, um_ia, um_ic] = unique(movies, 'sorted');
uniq.user = uniq_user;
uniq.movie = uniq_movie;
uniq.uuic = uu_ic;
uniq.uuia = uu_ia;
uniq.umia = um_ia;
uniq.umic = um_ic;



%% 
n_time_list = [5, 10, 20, 25, 30, 35, 40, 50];
f = figure;
f.Position = [50 50 1450 700];
for ttt = 1:length(n_time_list)
    n_time_slice = n_time_list(ttt);
    [edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
    n_genres = length( uniq_movie );
    rating_tensor = zeros(length(uniq_user), ...
                          n_genres, ...
                          n_time_slice);           
    size(rating_tensor)
    
    tic;
    for  i = 1:length(data)
        if mod(i,1000) ==0
            fprintf('�� %8d ����¼����: �� %5d �û� | �� %5d ��Ʒ | �� %2d ʱ��Ƭ\n', ...
                    i, uu_ic(i), um_ic(i), n_t);
        end
        % �����������¼ʱ�����ͬ���Թ�
        % ������һ�׸���˶����ǩҲֻ��Ϊһ��
        if i > 2
            if timestamps(i) == timestamps(i-1)
                continue
            end
        end
        n_t = z_which_slice(edge, timestamps(i));
        rating_tensor(uu_ic(i), um_ic(i), n_t) = ... 
                rating_tensor(uu_ic(i), um_ic(i), n_t) + 1;

    end
    toc        
    save(['lastfm_tensor_',num2str(n_time_slice)], 'rating_tensor')
    % -------------------------------------------------------------------------
    disp('[Info]��ʼ����ƽ������ >>>>>>>>>>>>>>>>');
    tic;
    mean_rating = zeros(n_time_slice, length(n_time_list));
    median_rating = zeros(n_time_slice, length(n_time_list));
    n_rated_in_slice = zeros(n_time_slice, length(n_time_list));
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
    fprintf("[Info]����ƽ�����ֺ�ʱ: %.4f �롣\n", t5);
end
% genre_tensor = rating_tensor;
% clear rating_tensor;
% save('lastfm_2k_tensor','genre_tensor','uniq','-v7.3');