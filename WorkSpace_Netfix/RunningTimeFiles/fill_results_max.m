
addpath(genpath('../Toolbox'))

train_miss = train_data == 0;

tsntd_hat = tsntd_result.tensor;
tsntd_hat(train_miss) = 0;
frob_err_tsntd = frob(tsntd_hat-train_data)/frob(train_data);

rcp_hat = rcp_result.tensor;
rcp_hat(train_miss) = 0;
frob_err_rcp = frob(rcp_hat-train_data)/frob(train_data);

upd_hat = upd_result.tensor;
upd_hat(train_miss) = 0;
frob_err_upd = frob(upd_hat-train_data)/frob(train_data);

smf_hat = smf_result.tensor;
smf_hat(train_miss) = 0;
frob_err_smf = frob(smf_hat-train_data)/frob(train_data);

mtmf_hat = mtmf_result.tensor;
mtmf_hat(train_miss) = 0;
frob_err_mtmf = frob(mtmf_hat-train_data)/frob(train_data);

fprintf("TSNTD: \t%.4f\nRCP: \t%.4f\nUPD: \t%.4f\nSMF: \t%.4f\nMTMF: \t%.4f\n",...
    frob_err_tsntd, frob_err_rcp, frob_err_upd, frob_err_smf, frob_err_mtmf)