% plot split results
clc;
% clear;
close all;
load('split_results.mat') 
n_time_list = [5, 10, 20, 25, 30, 35, 40, 50];

% for kk = 1:8
%     if kk > length(n_time_list)/2
%         subplot(4, length(n_time_list)/2, kk+length(n_time_list)*0.5);
%     else
%         subplot(4, length(n_time_list)/2, kk);
%     end
%     plot(mean_rating(mean_rating(:, kk)>0, kk), 'o:');
%     xlabel("k", 'FontName','Times New Roman', 'FontAngle', 'italic')
%     ylabel("mean rating", 'FontName','Times New Roman')
%     ylim([0, 40])
%     if kk > length(n_time_list)/2
%         subplot(4, length(n_time_list)/2, kk+length(n_time_list)*1);
%     else
%         subplot(4, length(n_time_list)/2, kk+length(n_time_list)*0.5);
%     end
%     bar(n_rated_in_slice(n_rated_in_slice(:, kk)>0, kk))
%     xlabel("k", 'FontName','Times New Roman', 'FontAngle', 'italic')
%     ylabel("frequency", 'FontName','Times New Roman')
% end   

% combine mean rating and frequence
for kk = 1:8
    subplot(2,4,kk)
    yyaxis left
    plot(mean_rating(mean_rating(:, kk)>0, kk), 'o:');
    xlabel("k", 'FontName','Times New Roman', 'FontAngle', 'italic')
    ylabel("mean rating", 'FontName','Times New Roman')
    ylim([0, 40])
    yyaxis right
    bar(n_rated_in_slice(n_rated_in_slice(:, kk)>0, kk))
    xlabel("k", 'FontName','Times New Roman', 'FontAngle', 'italic')
    ylabel("frequency", 'FontName','Times New Roman')
end
