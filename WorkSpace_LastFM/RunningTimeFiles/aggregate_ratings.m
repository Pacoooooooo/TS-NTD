function [agg_data] = aggregate_ratings(prev_data,type)
%z_aggregate_ratings 聚合函数
%   此处显示详细说明
% -------------------------------------------------------------------------
if strcmp(type, 'MAX') || strcmp(type, 'max')
    disp('(*****)Data Aggregate Type: MAX');
    agg_data = max(prev_data, [], 3);
end
if strcmp(type, 'MEAN')||strcmp(type, 'mean')
    disp('(*****)Data Aggregate Type: MEAN');
    agg_data = mean(prev_data, 3);
end
if strcmp(type, 'MVAVG')||strcmp(type, 'mvavg')
    disp('(*****)Data Aggregate Type: MVAVG');
    agg_data = movmean(prev_data,3,3);
    agg_data = (agg_data(:,:,end-2)+agg_data(:,:,end-1)+...
                agg_data(:,:,end))/3;
end

end

