% Histograms and shit

tiledlayout(2, 1)

nexttile

[n, x] = hist(diff_diff_rightleft, 25);
hold on

plot(x, n/sum(n), 'LineWidth', 2)

plot([mean(diff_diff_rightleft) mean(diff_diff_rightleft)], ...
     [0 max(n/sum(n))], '--', 'LineWidth', 1.5)

% --- ADDED ANNOTATION ---
title('Distribution of Difference-in-Differences (Right vs Left)')
xlabel('Difference-in-Differences')
ylabel('Probability')
legend('Normalized Histogram', 'Mean', 'Location', 'best')
grid on
% ------------------------

[H, P, CI, STATS] = ttest(diff_diff_rightleft, 0);
disp("DIFF DIFF : t(" + num2str(STATS.df) + ")=" + num2str(STATS.tstat) + " p=" + num2str(P));

[H, P, CI, STATS] = ttest(diff_right, 0);
disp("DIFF RIGHT: t(" + num2str(STATS.df) + ")=" + num2str(STATS.tstat) + " p=" + num2str(P));

[H, P, CI, STATS] = ttest(diff_left, 0);
disp("DIFF LEFT : t(" + num2str(STATS.df) + ")=" + num2str(STATS.tstat) + " p=" + num2str(P));

right_handed_diffdiff = diff_diff_rightleft(find(num(:, 2)==1), :);
left_handed_diffdiff = diff_diff_rightleft(find(num(:, 2)==2), :);

nexttile

% --- ADDED ANNOTATION (even though no plot exists) ---
title('Right vs Left Handed Comparison')
xlabel('Group')
ylabel('Difference ')
grid on
% ---------------------------------------------------

[H, P, CI, STATS] = ttest2(right_handed_diffdiff, left_handed_diffdiff);
disp("RIGHT      : t(" + num2str(STATS.df) + ")=" + num2str(STATS.tstat) + " p=" + num2str(P));