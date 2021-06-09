clc;
clear;


% ====================================================
actual = [
        1, 0, 0, 0;
        0, 0, 0, 1;
        0, 1, 0, 0;
        0, 0, 1, 0
    ];
predict = [
        1, 0, 0, 0;
        0, 0, 0, 1;
        0, 1, 0, 0;
        0, 0, 1, 0
    ];
opt.k = 1;
[fit_err, rec_acc] = evaluation(actual, predict, opt)

actual = [
        1, nan, nan, nan;
        nan, nan, nan, 1;
        nan, 1, nan, nan;
        nan, nan, 1, nan
    ];
predict = [
        1, nan, nan, nan;
        nan, nan, nan, 1;
        nan, 1, nan, nan;
        nan, nan, 1, nan
    ];
opt.k = 1;
[fit_err, rec_acc] = evaluation(actual, predict, opt)