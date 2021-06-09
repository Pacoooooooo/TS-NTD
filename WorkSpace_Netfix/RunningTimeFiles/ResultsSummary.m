%
% 心潤惚旗鷹
%==========================================================================
clc;clear;close all;

path_name = './Netfix_1022/';
list = dir(path_name);
% list = dir('./ML_1m/');

RCP_MAE = {};RCP_RMSE = {};
UPD_MAE = {};UPD_RMSE = {};
SMF_MAE = {};SMF_RMSE = {};
OUR_MAE = {};OUR_RMSE = {};
NEW_MAE = {};NEW_RMSE = {}; % 仟議扮寂�猖洞�

% -------------------------------------------------------------------------
lenlist = length(list)-2;

RCP_MAE.raw_max = zeros(lenlist/3,1);RCP_MAE.raw_mean = zeros(lenlist/3,1);RCP_MAE.raw_mvavg = zeros(lenlist/3,1);
UPD_MAE.raw_max = zeros(lenlist/3,1);UPD_MAE.raw_mean = zeros(lenlist/3,1);UPD_MAE.raw_mvavg = zeros(lenlist/3,1);
SMF_MAE.raw_max = zeros(lenlist/3,1);SMF_MAE.raw_mean = zeros(lenlist/3,1);SMF_MAE.raw_mvavg = zeros(lenlist/3,1);
OUR_MAE.raw_max = zeros(lenlist/3,1);OUR_MAE.raw_mean = zeros(lenlist/3,1);OUR_MAE.raw_mvavg = zeros(lenlist/3,1);
NEW_MAE.raw_max = zeros(lenlist/3,1);NEW_MAE.raw_mean = zeros(lenlist/3,1);NEW_MAE.raw_mvavg = zeros(lenlist/3,1);

RCP_RMSE.raw_max = zeros(lenlist/3,1);RCP_RMSE.raw_mean = zeros(lenlist/3,1);RCP_RMSE.raw_mvavg = zeros(lenlist/3,1);
UPD_RMSE.raw_max = zeros(lenlist/3,1);UPD_RMSE.raw_mean = zeros(lenlist/3,1);UPD_RMSE.raw_mvavg = zeros(lenlist/3,1);
SMF_RMSE.raw_max = zeros(lenlist/3,1);SMF_RMSE.raw_mean = zeros(lenlist/3,1);SMF_RMSE.raw_mvavg = zeros(lenlist/3,1);
OUR_RMSE.raw_max = zeros(lenlist/3,1);OUR_RMSE.raw_mean = zeros(lenlist/3,1);OUR_RMSE.raw_mvavg = zeros(lenlist/3,1);
NEW_RMSE.raw_max = zeros(lenlist/3,1);NEW_RMSE.raw_mean = zeros(lenlist/3,1);NEW_RMSE.raw_mvavg = zeros(lenlist/3,1);

x = 1;y = 1;z = 1;
for i = 1:lenlist
    result = list(i+2).name
    load([path_name,result])
    if strcmp('MAX', result(end-6:end-4))
        disp('======MAX=====')
        RCP_MAE.raw_max(x) = eval_rcp.mae;RCP_RMSE.raw_max(x) = eval_rcp.rmse;
        UPD_MAE.raw_max(x) = eval_upd.mae;UPD_RMSE.raw_max(x) = eval_upd.rmse;
        SMF_MAE.raw_max(x) = eval_smf.mae;SMF_RMSE.raw_max(x) = eval_smf.rmse;
        OUR_MAE.raw_max(x) = eval_tsim.mae;OUR_RMSE.raw_max(x) = eval_tsim.rmse;  
        NEW_MAE.raw_max(x) = eval_tprs.mae;NEW_RMSE.raw_max(x) = eval_tprs.rmse;
        x = x+1
    end
    if strcmp('EAN', result(end-6:end-4))
        disp('======MEAN=====')
        RCP_MAE.raw_mean(y) = eval_rcp.mae;RCP_RMSE.raw_mean(y) = eval_rcp.rmse;
        UPD_MAE.raw_mean(y) = eval_upd.mae;UPD_RMSE.raw_mean(y) = eval_upd.rmse;
        SMF_MAE.raw_mean(y) = eval_smf.mae;SMF_RMSE.raw_mean(y) = eval_smf.rmse;
        OUR_MAE.raw_mean(y) = eval_tsim.mae;OUR_RMSE.raw_mean(y) = eval_tsim.rmse;
        NEW_MAE.raw_mean(y) = eval_tprs.mae;NEW_RMSE.raw_mean(y) = eval_tprs.rmse;
        y = y+1
    end
    if strcmp('AVG', result(end-6:end-4))
        disp('======AVG=====')
        RCP_MAE.raw_mvavg(z) = eval_rcp.mae;RCP_RMSE.raw_mvavg(z) = eval_rcp.rmse;
        UPD_MAE.raw_mvavg(z) = eval_upd.mae;UPD_RMSE.raw_mvavg(z) = eval_upd.rmse;
        SMF_MAE.raw_mvavg(z) = eval_smf.mae;SMF_RMSE.raw_mvavg(z) = eval_smf.rmse;
        OUR_MAE.raw_mvavg(z) = eval_tsim.mae;OUR_RMSE.raw_mvavg(z) = eval_tsim.rmse;
        NEW_MAE.raw_mvavg(z) = eval_tprs.mae;NEW_RMSE.raw_mvavg(z) = eval_tprs.rmse;
        z = z+1
    end
end
%% [TOP-1] ========================================================
TopResult = 1;
% -------------------------------------------------------------------------
temp = sort(RCP_MAE.raw_max);RCP_MAE.m1_max = mean(temp(1:TopResult));
temp = sort(RCP_MAE.raw_mean);RCP_MAE.m1_mean = mean(temp(1:TopResult));
temp = sort(RCP_MAE.raw_mvavg);RCP_MAE.m1_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(RCP_RMSE.raw_max);RCP_RMSE.m1_max = mean(temp(1:TopResult));
temp = sort(RCP_RMSE.raw_mean);RCP_RMSE.m1_mean = mean(temp(1:TopResult));
temp = sort(RCP_RMSE.raw_mvavg);RCP_RMSE.m1_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(UPD_MAE.raw_max);UPD_MAE.m1_max = mean(temp(1:TopResult));
temp = sort(UPD_MAE.raw_mean);UPD_MAE.m1_mean = mean(temp(1:TopResult));
temp = sort(UPD_MAE.raw_mvavg);UPD_MAE.m1_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(UPD_RMSE.raw_max);UPD_RMSE.m1_max = mean(temp(1:TopResult));
temp = sort(UPD_RMSE.raw_mean);UPD_RMSE.m1_mean = mean(temp(1:TopResult));
temp = sort(UPD_RMSE.raw_mvavg);UPD_RMSE.m1_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(SMF_MAE.raw_max);SMF_MAE.m1_max = mean(temp(1:TopResult));
temp = sort(SMF_MAE.raw_mean);SMF_MAE.m1_mean = mean(temp(1:TopResult));
temp = sort(SMF_MAE.raw_mvavg);SMF_MAE.m1_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(SMF_RMSE.raw_max);SMF_RMSE.m1_max = mean(temp(1:TopResult));
temp = sort(SMF_RMSE.raw_mean);SMF_RMSE.m1_mean = mean(temp(1:TopResult));
temp = sort(SMF_RMSE.raw_mvavg);SMF_RMSE.m1_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(OUR_MAE.raw_max);OUR_MAE.m1_max = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mean);OUR_MAE.m1_mean = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mvavg);OUR_MAE.m1_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(OUR_RMSE.raw_max);OUR_RMSE.m1_max = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mean);OUR_RMSE.m1_mean = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mvavg);OUR_RMSE.m1_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(OUR_MAE.raw_max);OUR_MAE.m1_max = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mean);OUR_MAE.m1_mean = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mvavg);OUR_MAE.m1_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(OUR_RMSE.raw_max);OUR_RMSE.m1_max = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mean);OUR_RMSE.m1_mean = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mvavg);OUR_RMSE.m1_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(NEW_MAE.raw_max);NEW_MAE.m1_max = mean(temp(1:TopResult));
temp = sort(NEW_MAE.raw_mean);NEW_MAE.m1_mean = mean(temp(1:TopResult));
temp = sort(NEW_MAE.raw_mvavg);NEW_MAE.m1_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(NEW_RMSE.raw_max);NEW_RMSE.m1_max = mean(temp(1:TopResult));
temp = sort(NEW_RMSE.raw_mean);NEW_RMSE.m1_mean = mean(temp(1:TopResult));
temp = sort(NEW_RMSE.raw_mvavg);NEW_RMSE.m1_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
%% [TOP-3] ========================================================
TopResult = 3;
% -------------------------------------------------------------------------
temp = sort(RCP_MAE.raw_max);RCP_MAE.m3_max = mean(temp(1:TopResult));
temp = sort(RCP_MAE.raw_mean);RCP_MAE.m3_mean = mean(temp(1:TopResult));
temp = sort(RCP_MAE.raw_mvavg);RCP_MAE.m3_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(RCP_RMSE.raw_max);RCP_RMSE.m3_max = mean(temp(1:TopResult));
temp = sort(RCP_RMSE.raw_mean);RCP_RMSE.m3_mean = mean(temp(1:TopResult));
temp = sort(RCP_RMSE.raw_mvavg);RCP_RMSE.m3_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(UPD_MAE.raw_max);UPD_MAE.m3_max = mean(temp(1:TopResult));
temp = sort(UPD_MAE.raw_mean);UPD_MAE.m3_mean = mean(temp(1:TopResult));
temp = sort(UPD_MAE.raw_mvavg);UPD_MAE.m3_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(UPD_RMSE.raw_max);UPD_RMSE.m3_max = mean(temp(1:TopResult));
temp = sort(UPD_RMSE.raw_mean);UPD_RMSE.m3_mean = mean(temp(1:TopResult));
temp = sort(UPD_RMSE.raw_mvavg);UPD_RMSE.m3_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(SMF_MAE.raw_max);SMF_MAE.m3_max = mean(temp(1:TopResult));
temp = sort(SMF_MAE.raw_mean);SMF_MAE.m3_mean = mean(temp(1:TopResult));
temp = sort(SMF_MAE.raw_mvavg);SMF_MAE.m3_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(SMF_RMSE.raw_max);SMF_RMSE.m3_max = mean(temp(1:TopResult));
temp = sort(SMF_RMSE.raw_mean);SMF_RMSE.m3_mean = mean(temp(1:TopResult));
temp = sort(SMF_RMSE.raw_mvavg);SMF_RMSE.m3_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(OUR_MAE.raw_max);OUR_MAE.m3_max = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mean);OUR_MAE.m3_mean = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mvavg);OUR_MAE.m3_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(OUR_RMSE.raw_max);OUR_RMSE.m3_max = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mean);OUR_RMSE.m3_mean = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mvavg);OUR_RMSE.m3_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(NEW_MAE.raw_max);NEW_MAE.m3_max = mean(temp(1:TopResult));
temp = sort(NEW_MAE.raw_mean);NEW_MAE.m3_mean = mean(temp(1:TopResult));
temp = sort(NEW_MAE.raw_mvavg);NEW_MAE.m3_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(NEW_RMSE.raw_max);NEW_RMSE.m3_max = mean(temp(1:TopResult));
temp = sort(NEW_RMSE.raw_mean);NEW_RMSE.m3_mean = mean(temp(1:TopResult));
temp = sort(NEW_RMSE.raw_mvavg);NEW_RMSE.m3_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
%% [TOP-15] ========================================================
TopResult = 5;
% -------------------------------------------------------------------------
temp = sort(RCP_MAE.raw_max);RCP_MAE.m15_max = mean(temp(1:TopResult));
temp = sort(RCP_MAE.raw_mean);RCP_MAE.m15_mean = mean(temp(1:TopResult));
temp = sort(RCP_MAE.raw_mvavg);RCP_MAE.m15_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(RCP_RMSE.raw_max);RCP_RMSE.m15_max = mean(temp(1:TopResult));
temp = sort(RCP_RMSE.raw_mean);RCP_RMSE.m15_mean = mean(temp(1:TopResult));
temp = sort(RCP_RMSE.raw_mvavg);RCP_RMSE.m15_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(UPD_MAE.raw_max);UPD_MAE.m15_max = mean(temp(1:TopResult));
temp = sort(UPD_MAE.raw_mean);UPD_MAE.m15_mean = mean(temp(1:TopResult));
temp = sort(UPD_MAE.raw_mvavg);UPD_MAE.m15_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(UPD_RMSE.raw_max);UPD_RMSE.m15_max = mean(temp(1:TopResult));
temp = sort(UPD_RMSE.raw_mean);UPD_RMSE.m15_mean = mean(temp(1:TopResult));
temp = sort(UPD_RMSE.raw_mvavg);UPD_RMSE.m15_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(SMF_MAE.raw_max);SMF_MAE.m15_max = mean(temp(1:TopResult));
temp = sort(SMF_MAE.raw_mean);SMF_MAE.m15_mean = mean(temp(1:TopResult));
temp = sort(SMF_MAE.raw_mvavg);SMF_MAE.m15_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(SMF_RMSE.raw_max);SMF_RMSE.m15_max = mean(temp(1:TopResult));
temp = sort(SMF_RMSE.raw_mean);SMF_RMSE.m15_mean = mean(temp(1:TopResult));
temp = sort(SMF_RMSE.raw_mvavg);SMF_RMSE.m15_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(OUR_MAE.raw_max);OUR_MAE.m15_max = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mean);OUR_MAE.m15_mean = mean(temp(1:TopResult));
temp = sort(OUR_MAE.raw_mvavg);OUR_MAE.m15_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(OUR_RMSE.raw_max);OUR_RMSE.m15_max = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mean);OUR_RMSE.m15_mean = mean(temp(1:TopResult));
temp = sort(OUR_RMSE.raw_mvavg);OUR_RMSE.m15_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
temp = sort(NEW_MAE.raw_max);NEW_MAE.m15_max = mean(temp(1:TopResult));
temp = sort(NEW_MAE.raw_mean);NEW_MAE.m15_mean = mean(temp(1:TopResult));
temp = sort(NEW_MAE.raw_mvavg);NEW_MAE.m15_mvavg = mean(temp(1:TopResult));
% -，-，-，-，-，-，-，-，-，--，-，-，-，-，-，--，-，--，-，-，-，-，-，-，-
temp = sort(NEW_RMSE.raw_max);NEW_RMSE.m15_max = mean(temp(1:TopResult));
temp = sort(NEW_RMSE.raw_mean);NEW_RMSE.m15_mean = mean(temp(1:TopResult));
temp = sort(NEW_RMSE.raw_mvavg);NEW_RMSE.m15_mvavg = mean(temp(1:TopResult));
% -------------------------------------------------------------------------
%%
% =========================================================================
Data = [RCP_MAE.m1_max,RCP_MAE.m3_max,RCP_MAE.m15_max,...
        RCP_MAE.m1_mean,RCP_MAE.m3_mean,RCP_MAE.m15_mean,...
        RCP_MAE.m1_mvavg,RCP_MAE.m3_mvavg,RCP_MAE.m15_mvavg,... %-，-
        RCP_RMSE.m1_max,RCP_RMSE.m3_max,RCP_RMSE.m15_max,...
        RCP_RMSE.m1_mean,RCP_RMSE.m3_mean,RCP_RMSE.m15_mean,...
        RCP_RMSE.m1_mvavg,RCP_RMSE.m3_mvavg,RCP_RMSE.m15_mvavg;...% \\
        
        UPD_MAE.m1_max,UPD_MAE.m3_max,UPD_MAE.m15_max,...
        UPD_MAE.m1_mean,UPD_MAE.m3_mean,UPD_MAE.m15_mean,...
        UPD_MAE.m1_mvavg,UPD_MAE.m3_mvavg,UPD_MAE.m15_mvavg,... %-，-
        UPD_RMSE.m1_max,UPD_RMSE.m3_max,UPD_RMSE.m15_max,...
        UPD_RMSE.m1_mean,UPD_RMSE.m3_mean,UPD_RMSE.m15_mean,...
        UPD_RMSE.m1_mvavg,UPD_RMSE.m3_mvavg,UPD_RMSE.m15_mvavg;...% \\
        
        SMF_MAE.m1_max,SMF_MAE.m3_max,SMF_MAE.m15_max,...
        SMF_MAE.m1_mean,SMF_MAE.m3_mean,SMF_MAE.m15_mean,...
        SMF_MAE.m1_mvavg,SMF_MAE.m3_mvavg,SMF_MAE.m15_mvavg,... %-，-
        SMF_RMSE.m1_max,SMF_RMSE.m3_max,SMF_RMSE.m15_max,...
        SMF_RMSE.m1_mean,SMF_RMSE.m3_mean,SMF_RMSE.m15_mean,...
        SMF_RMSE.m1_mvavg,SMF_RMSE.m3_mvavg,SMF_RMSE.m15_mvavg;...% \\
        
        OUR_MAE.m1_max,OUR_MAE.m3_max,OUR_MAE.m15_max,...
        OUR_MAE.m1_mean,OUR_MAE.m3_mean,OUR_MAE.m15_mean,...
        OUR_MAE.m1_mvavg,OUR_MAE.m3_mvavg,OUR_MAE.m15_mvavg,... %-，-
        OUR_RMSE.m1_max,OUR_RMSE.m3_max,OUR_RMSE.m15_max,...
        OUR_RMSE.m1_mean,OUR_RMSE.m3_mean,OUR_RMSE.m15_mean,...
        OUR_RMSE.m1_mvavg,OUR_RMSE.m3_mvavg,OUR_RMSE.m15_mvavg;...% \\
        
        NEW_MAE.m1_max,NEW_MAE.m3_max,NEW_MAE.m15_max,...
        NEW_MAE.m1_mean,NEW_MAE.m3_mean,NEW_MAE.m15_mean,...
        NEW_MAE.m1_mvavg,NEW_MAE.m3_mvavg,NEW_MAE.m15_mvavg,... %-，-
        NEW_RMSE.m1_max,NEW_RMSE.m3_max,NEW_RMSE.m15_max,...
        NEW_RMSE.m1_mean,NEW_RMSE.m3_mean,NEW_RMSE.m15_mean,...
        NEW_RMSE.m1_mvavg,NEW_RMSE.m3_mvavg,NEW_RMSE.m15_mvavg;...% \\
    ];
EvalTable = array2table(Data,...
            'VariableNames',{'Mmax_1','Mmax_3','Mmax_15','Mmean_1','Mmean_3','Mmean_15','Mmvavg_1','Mmvavg_3','Mmvavg_15',...
                            'Rmax_1','Rmax_3','Rmax_15','Rmean_1','Rmean_3','Rmean_15','Rmvavg_1','Rmvavg_3','Rmvavg_15'},...
            'RowNames',{'RCP','UPD','SMF','OUR','NEW'});
EvalTable