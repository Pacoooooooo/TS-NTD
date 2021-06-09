% how to split time periods

clc;
clear;
close all;
%%
disp('[Info]��ʼ�������� >>>>>>>>>>>>>>>>')
tic;
load('./new_movie_records.mat')
t = toc;
movie_records = new_movie_records;
clear new_movie_records;
fprintf('[Info]�������ݺ�ʱ: %.4f �롣\n', t);
% -------------------------------------------------------------------------
disp('[Info]��ʼ���� unique >>>>>>>>>>>>>>>>')
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
fprintf("[Info]����unique��ʱ: %.4f �롣\n", t2);

n_time_list = [3, 5,10, 15, 20, 25, 30, 50]; % ����ż����
f1 = figure;
f1.Position = [50 50 1450 700];
mean_rating = zeros(max(n_time_list), length(n_time_list));
median_rating = zeros(max(n_time_list), length(n_time_list));
n_rated_in_slice = zeros(max(n_time_list), length(n_time_list));
for kk = 1:length(n_time_list)
    % -------------------------------------------------------------------------
    disp('[Info]��ʼ���� time periods >>>>>>>>>>>>>>>>');
    tic;
    n_time_slice = n_time_list(kk);
    [edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
    t3 = toc;
    fprintf("[Info]����ʱ��Ƭ��ʱ: %.4f �롣\n", t3);

    % -------------------------------------------------------------------------
    disp('[Info]��ʼ������������ >>>>>>>>>>>>>>>>');
    visit_tensor = zeros(length(uniq_user), ...
                          length(uniq_movie), ...
                          n_time_slice); 
    s = size(visit_tensor);
    fprintf("[Info] n_user: %5d, n_item: %5d, n_time: %5d", s(1), s(2), s(3));

    loop_times = length(movie_records);
    fprintf('\n====================================================================================================\n');
    for  i = 1:loop_times
        if mod(i, floor(loop_times/10)) ==0
    %         fprintf('�� %8d ����¼����: �� %5d �û� | �� %5d ��Ʒ | �� %2d ʱ��Ƭ\n', ...
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
    fprintf("[Info]��������������ʱ: %.4f �롣\n", t4);

    % -------------------------------------------------------------------------
    disp('[Info]��ʼ����ƽ������ >>>>>>>>>>>>>>>>');
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
    fprintf("[Info]����ƽ�����ֺ�ʱ: %.4f �롣\n", t5);
end
save('split_results', 'n_rated_in_slice',  'mean_rating');

