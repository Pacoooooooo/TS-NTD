clc;
close;
clear all;


%% txt --> mat: �ⲿ�ֵĴ����ʱ�ܴ�
%{
dir_path = './netfix_sub_2M-472_3K-964/'
movie_files = dir(dir_path);
movie_records = [];
start_num = 1;
end_num = length(movie_files);
try
    for i = start_num:end_num
        if mod(i, 100) == 0
            save('movie_records.mat', 'movie_records');
        end
        if mod(i, 1) == 0
            fprintf('%6d ... ', i)
        end
        if ~ movie_files(i).isdir 
            fprintf('%s  \n', movie_files(i).name)
            records = parse_movie_file([dir_path, movie_files(i).name]);
            movie_records = [movie_records; records];
        else
            fprintf('[DIR]%s  \n', movie_files(i).name)
        end
    end
catch
    save('movie_records.mat', 'movie_records');
end
save('movie_records.mat', 'movie_records');
%}

%% ɾ�������û�
%   �ܹ��� 19615299 ����¼��1184 movies��469302 users��2182 timestamps
%   ɾ�� �ۿ���¼����10�ʹ���200000 ���û���Ҳ����ɾ���ۿ���¼���� 10 ���û�
%
tic;
load('./movie_records.mat')
disp('�������ݺ�ʱ��')
toc

tic
movie_id = movie_records(:,1);      % 19615299 x 1
user_id = movie_records(:, 2);      % 19615299 x 1
timestamp = movie_records(:,4);     % 19615299 x 1
um = unique(movie_id);              % 1184 x 1
[uu, uu_ia, uu_ic] = unique(user_id);               % 469302 x 1
ut = unique(timestamp);             % 2182 x 1
disp('����unique��ʱ��')
toc

tic;
count_user = hist(user_id, uu)';    % 469302 x 1
disp('ͳ�ƴ�����ʱ��')
toc

low_threshold = 10; high_threshold = 200000;  % ռ�� 0.1781
keep_prob = 1;
keep_user_id = uu(count_user>low_threshold & count_user < high_threshold);  % Ҫ�������û�id
keep_user_id = keep_user_id(rand(size(keep_user_id))<keep_prob);
keep_record_index = zeros(length(movie_records), 1);                        % Ҫ�����ļ�¼�±�
tic;
fprintf('\n====================================================================================================\n');
loop_times = length(movie_records);
j = 1;
parfor i = 1:loop_times
    if mod(i, floor(loop_times/100)) == 0
        print_process_bar(i, loop_times);
%         size(keep_record_index)
    end
    
    % ͨ���������ж�
%     user_idx = uu_ic(i);
%     visit_times = count_user(user_idx);
%     if visit_times > low_threshold 
%         if visit_times < high_threshold
%             keep_record_index(j) = i; j = j+1;
%         end
%     end
    
    % ͨ���û�id���ж�
    if ismember(user_id(i), keep_user_id)
        keep_record_index(i) = i; 
    end
end
disp('ɾ���û���ʱ��')
toc
size(keep_record_index)
keep_record_index = keep_record_index(keep_record_index>0);size(keep_record_index)
new_movie_records = movie_records(keep_record_index, :);
save('new_movie_records.mat', 'new_movie_records', 'keep_record_index');
new_uu = unique(new_movie_records(:,2));
clear movie_records
%}

%% ����¼ת��������
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% ����Netfix���ݼ�ÿ��userֻ�ῴһ����Ӱһ�Σ����Բ��ܽ�visit������Ϊ����
% Ԫ�ص�ֵ����Ӧ��ֱ���� rating ��ֵ��
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!��
%
tic;
load('./new_movie_records.mat')
disp('�������ݺ�ʱ��')
toc
movie_records = new_movie_records;
clear new_movie_records;


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
disp('����unique��ʱ��')
toc
% 
% tic;
n_time_slice = 20;
[edge, values] = z_timestamp_histogram(timestamps,n_time_slice);
visit_tensor = zeros(length(uniq_user), ...
                      length(uniq_movie), ...
                      n_time_slice); 
size(visit_tensor)

loop_times = length(movie_records);
fprintf('\n====================================================================================================\n');
for  i = 1:loop_times
    if mod(i, floor(loop_times/50)) ==0
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
disp('����������ʱ��')
toc

tic;
% save('netfix_sub_tensor', 'visit_tensor',  '-v7.3', '-nocompression');
save('netfix_sub_tensor', 'visit_tensor',  '-v7.3');
disp('���������ʱ��')
toc
%}

