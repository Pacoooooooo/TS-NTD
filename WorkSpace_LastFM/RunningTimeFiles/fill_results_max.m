% fill results
% 在 Run_Evaluation 中被调用

EVALUATION_SUMMARY_MAX(1, 1, i) = rTSNTD.fit_max.mae;
EVALUATION_SUMMARY_MAX(1, 2, i) = rTSNTD.fit_max.rmse;
EVALUATION_SUMMARY_MAX(1, 3, i) = rTSNTD.rec_max.precision(1);
EVALUATION_SUMMARY_MAX(1, 4, i) = rTSNTD.rec_max.precision(2);
EVALUATION_SUMMARY_MAX(1, 5, i) = rTSNTD.rec_max.recall(1);
EVALUATION_SUMMARY_MAX(1, 6, i) = rTSNTD.rec_max.recall(2);
EVALUATION_SUMMARY_MAX(1, 7, i) = rTSNTD.rec_max.f1score(1);
EVALUATION_SUMMARY_MAX(1, 8, i) = rTSNTD.rec_max.f1score(2);
EVALUATION_SUMMARY_MAX(1, 9, i) = rTSNTD.cost_time;

EVALUATION_SUMMARY_MAX(2, 1, i) = rNTD.fit_max.mae;
EVALUATION_SUMMARY_MAX(2, 2, i) = rNTD.fit_max.rmse;
EVALUATION_SUMMARY_MAX(2, 3, i) = rNTD.rec_max.precision(1);
EVALUATION_SUMMARY_MAX(2, 4, i) = rNTD.rec_max.precision(2);
EVALUATION_SUMMARY_MAX(2, 5, i) = rNTD.rec_max.recall(1);
EVALUATION_SUMMARY_MAX(2, 6, i) = rNTD.rec_max.recall(2);
EVALUATION_SUMMARY_MAX(2, 7, i) = rNTD.rec_max.f1score(1);
EVALUATION_SUMMARY_MAX(2, 8, i) = rNTD.rec_max.f1score(2);
EVALUATION_SUMMARY_MAX(2, 9, i) = rNTD.cost_time;

EVALUATION_SUMMARY_MAX(3, 1, i) = rRCP.fit_max.mae;
EVALUATION_SUMMARY_MAX(3, 2, i) = rRCP.fit_max.rmse;
EVALUATION_SUMMARY_MAX(3, 3, i) = rRCP.rec_max.precision(1);
EVALUATION_SUMMARY_MAX(3, 4, i) = rRCP.rec_max.precision(2);
EVALUATION_SUMMARY_MAX(3, 5, i) = rRCP.rec_max.recall(1);
EVALUATION_SUMMARY_MAX(3, 6, i) = rRCP.rec_max.recall(2);
EVALUATION_SUMMARY_MAX(3, 7, i) = rRCP.rec_max.f1score(1);
EVALUATION_SUMMARY_MAX(3, 8, i) = rRCP.rec_max.f1score(2);
EVALUATION_SUMMARY_MAX(3, 9, i) = rRCP.cost_time;

EVALUATION_SUMMARY_MAX(4, 1, i) = rRCP.fit_max.mae;
EVALUATION_SUMMARY_MAX(4, 2, i) = rRCP.fit_max.rmse;
EVALUATION_SUMMARY_MAX(4, 3, i) = rRCP.rec_max.precision(1);
EVALUATION_SUMMARY_MAX(4, 4, i) = rRCP.rec_max.precision(2);
EVALUATION_SUMMARY_MAX(4, 5, i) = rRCP.rec_max.recall(1);
EVALUATION_SUMMARY_MAX(4, 6, i) = rRCP.rec_max.recall(2);
EVALUATION_SUMMARY_MAX(4, 7, i) = rRCP.rec_max.f1score(1);
EVALUATION_SUMMARY_MAX(4, 8, i) = rRCP.rec_max.f1score(2);
EVALUATION_SUMMARY_MAX(4, 9, i) = rRCP.cost_time;






