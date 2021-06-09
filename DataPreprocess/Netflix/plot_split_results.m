% plot split results
clc;
clear;
close all;
load('split_results.mat') 
n_time_list = [3, 5,10, 15, 20, 25, 30, 50];

for kk = 1:8
    if kk > length(n_time_list)/2
        subplot(4, length(n_time_list)/2, kk+length(n_time_list)*0.5);
    else
        subplot(4, length(n_time_list)/2, kk);
    end
    plot(mean_rating(mean_rating(:, kk)>0, kk), 'o:');
    xlabel("k","FontName","Times New Roman", "FontAngle","italic")
    ylabel("mean rating", "FontName","Times New Roman")
    ylim([2.8, 4])
    if kk > length(n_time_list)/2
        subplot(4, length(n_time_list)/2, kk+length(n_time_list)*1);
    else
        subplot(4, length(n_time_list)/2, kk+length(n_time_list)*0.5);
    end
    bar(n_rated_in_slice(n_rated_in_slice(:, kk)>0, kk))
    xlabel("k","FontName","Times New Roman", "FontAngle","italic")
    ylabel("frequency", "FontName","Times New Roman")
end   

