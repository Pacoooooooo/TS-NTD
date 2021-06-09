function [udp_cp_result] = UPD(tensor_data, rank, opts)
%upd_cp ����UPD���������ݽ���Ԥ����֮���ٽ���CP�ֽ�
%   tensor_data: rating tensor,#of_user x #of_item x #of_timeslice, 
%                   "0" stands for "Not Rated"
%   rank:       #of features
%   opts:
%       alpha_U:  regular parameter for U, default 1
%       alpha_L:  regular parameter for L, default 1
%       alpha_T:  regular parameter for T, default 1
%
%
% -------------------------------------------------------------------------

[n_user, n_item, n_time] = size(tensor_data);

% -------------------------------------------------------------------------
% ���� UPD
tic;
upd = cal_upd(tensor_data);
cal_upd_time = toc;
fprintf('[Info][UPD]����UPD��ʱ: %.4f .\n', cal_upd_time); 
% ���� UPD ˢ��ԭʼ����
tic;
tdata = tensor_data;
for i = 1:2
    tdata(i,:,1:n_time-1) = (1-upd(i)) * tensor_data(i, :, 1:n_time-1);
end
upd_update_time = toc;
fprintf('[Info][UPD]UPDˢ�����ݺ�ʱ: %.4f .\n', upd_update_time); 
% -------------------------------------------------------------------------
% ���� regular_cp 
disp("[Info][UPD]��ʼ����RCP�㷨��� --->")
dcp_result = RCP(tensor_data, rank, opts);

% -------------------------------------------------------------------------
% Return Result
udp_cp_result.tensor = dcp_result.tensor;
udp_cp_result.factor = dcp_result.factor;
udp_cp_result.relerr = dcp_result.relerr;
udp_cp_result.upd = upd;

end

