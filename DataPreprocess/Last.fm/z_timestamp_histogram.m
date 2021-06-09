function [edges,values] = z_timestamp_histogram(timestamp, n_bin)
%timestamp_histogram 根据时间戳显示评分数量分布
%   timestamp: UNIX时间戳
%   n_bin: 分块数量

sorted_ts = sort(timestamp);
edges = linspace(sorted_ts(1)-1,sorted_ts(end)+1,n_bin+1);
f = histogram(sorted_ts,edges);
values = double(f.Values);
% fprintf('   [START]   \t    [END]     \t  [VALUE]   \t [RATE] \n')
for i = 1:length(edges)-1
    s = z_timestamp_to_str(edges(i));
    v = values(i);
    e = z_timestamp_to_str(edges(i+1));
%     fprintf(' %s \t %s \t %10d \t %.2f\n',...
%         s(1:11),e(1:11),v,v/length(timestamp));
end

end

