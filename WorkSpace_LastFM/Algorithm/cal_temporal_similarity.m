function [SIGMA] = cal_temporal_similarity(history_data, GAMMA)
%����ʱ��Ƭ�����ԣ��µļ��㷽����
%   tensor_data:    ����/Ƶ�� ��������
%   GAMMA:          ��Ʒ���ж�Ȩ�ص������ӣ�GAMMAԽ����Ʒ���ж�Ӱ��Խ��
%   SIGMA:           ���ƶȾ���
% ---------------------------------------------------------
% �µ�ʱ�������Կ����˸�������ء�
% S(R^t, R^{t-1}) =   mean_user_sim 
% mean_user_sim = 1/M * \sum_{u=1}^{u=M} S_u
% S_u = cos(R'_{:,u,t}, R'_{:,u,t-1})
% R'_{:,u,t} = R_{:,u,t}* popularity_item_weight
% =========================================================

% ȱʧ����ʾ
MISS_FLAG = mode(history_data, 'all');
miss_ratio = sum(history_data(:) == MISS_FLAG)/numel(history_data);
fprintf("[Info][cal_temporal_similarity] ���ݼ�ȱʧ�ʣ�%.4f\n", miss_ratio);

% =========================================================================
% ��ʼ���� SIGMA
    [~, ~, n_time] = size(history_data);
    time_sim_vector = ones(n_time,1);
    time_sim_vector(1) = 1;
    for t = 2:n_time
        time_sim_vector(t) = h_get_temporal_sim(history_data(:,:,t-1), ...
                                                history_data(:,:,t), ...
                                                GAMMA, MISS_FLAG);
    end
    SIGMA = diag(-time_sim_vector);
    SIGMA(1,1) = 1;
    for t = 2:n_time
       SIGMA(t, t-1) = - SIGMA(t,t); 
    end
%     ts = datestr(datetime('now'));
%     file_name = ['SIGMA_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.mat'];
%     save(file_name, 'SIGMA')
end

%% ================================================================
%   Sub-Function
% =========================================================================


function [nT1,nT2] = h_get_item_weight_matrix(T1,T2,GAMMA, MISS_FLAG)
% h_get_item_weight_matrix: ������Ʒ�����ж�Ȩ��
    [n_item, n_user] = size(T1);
    item_weight = zeros(n_item,2);
%     miss_ratio = sum(ismissing(T1(:)))/numel(T1);
%     fprintf(">h_get_item_weight_matrix< T1����ȱʧ�ʣ�%.4f\n", miss_ratio);
    for i = 1:n_item
        I1 = T1(i,:);
        I2 = T2(i,:);
        n_rated1 = sum(sum(I1==MISS_FLAG)); 
        p_ratio1 = 1 - (n_rated1 / n_user); % popular ratio
        n_rated2 = sum(sum(I2==MISS_FLAG)); 
        p_ratio2 = 1 - (n_rated2 / n_user);
        if (p_ratio1 > 0.05 || p_ratio2 > 0.05) && 0
            fprintf("item: %2d, r1: %.5f, r2: %.5f\n", ...
                i, p_ratio1, p_ratio2);
        end
%         GAMMA = 0.1;
        item_weight(i,1) = 2*(1 - 1/(1+exp(-GAMMA*p_ratio1)));
        item_weight(i,2) = 2*(1 - 1/(1+exp(-GAMMA*p_ratio2)));
    end
    nT1 = T1;
    nT2 = T2;
    for u = 1:n_user
        nT1(:,u) = item_weight(:,1) .* T1(:,u);
        nT2(:,u) = item_weight(:,2) .* T2(:,u);
    end
end

function mean_user_sim = h_get_temporal_sim(T1, T2, GAMMA, MISS_FLAG)
    sparse_T1 = T1;
    sparse_T2 = T2;
    
    mean_user_sim = 0;
    [~, n_user] = size(T1);
    [T1, T2] = h_get_item_weight_matrix(sparse_T1,sparse_T2, GAMMA, MISS_FLAG);
    % ��ȱʧ��ԭʼ��0��䣬�û�����COS���ƶ�
    T1(T1==MISS_FLAG) = 0;
    T2(T2==MISS_FLAG) = 0;
    for u = 1:n_user
        x = T1(:,u); x = reshape(x,[],1);
        y = T2(:,u); y = reshape(y,[],1);
%         temp = x'*y / (norm(x)*norm(y)+eps);
        temp = h_cal_jaccard_similarity(x, y);
        mean_user_sim = temp + mean_user_sim;
    end
    mean_user_sim = mean_user_sim/n_user;
end

function jc_sim = h_cal_jaccard_similarity(T1, T2)
n_item = length(T1);
rated_1 = find(T1);
rated_2 = find(T2);
rated_diff = abs(length(rated_1) - length(rated_2));
common_ = intersect(rated_1, rated_2);
union_ = union(rated_1, rated_2);
if numel(common_) > 0
    jc_sim = numel(common_) / numel(union_);
else
%     jc_sim = 1 - 1/(1+exp(-( (rated_diff-(n_item/2)) / (n_item/5) ) ));
    jc_sim = 1 - (rated_diff/n_item);
end 
% fprintf("Common num: %4d, Union num: %4d , rated_diff:%4d, JS: %.4f \n", numel(common_) , numel(union_), rated_diff, jc_sim);

end
