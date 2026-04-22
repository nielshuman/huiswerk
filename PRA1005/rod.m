    clear all, close all, clc
    
    [num, textFUCKingkutzooi, raw] = xlsread("group_data_2026.xls");
    
    N = size(num, 1);
    
    N_male = sum(num(:, 1) == 1);
    N_female = sum(num(:, 1) == 2);
    N_X = sum(num(:, 1) == 3);
    
    N_righthanded = sum(num(:, 2) == 1);
    N_lefthanded = sum(num(:, 2) == 2);
    N_otherhanded = sum(num(:, 2) == 0);
    
    mean_times_condition(:, 1) = mean(num(:,3:8), 2);
    mean_times_condition(:, 2) = mean(num(:,9:14), 2);
    mean_times_condition(:, 3) = mean(num(:,15:20), 2);
    mean_times_condition(:, 4) = mean(num(:,21:26), 2);
    
    overall_mean_time = mean(num(:, 3:26), 2);
    
    mean_time_norm = mean_times_condition ./ overall_mean_time;
    
    diff_right = (mean_time_norm(:, 2) - mean_time_norm(:, 1)); % speaking - silent
    diff_left = (mean_time_norm(:, 4) - mean_time_norm(:, 3)); % speaking - silent
    
    diff_diff_rightleft = diff_right - diff_left;
    
    % Histograms and shit
    tiledlayout(3, 2)
    
    %% --- 1. Overall distribution ---
    nexttile
    [n, x] = hist(diff_diff_rightleft, 25);
    hold on
    plot(x, n/sum(n), 'LineWidth', 2)
    plot([mean(diff_diff_rightleft) mean(diff_diff_rightleft)], [0 max(n/sum(n))], '--', 'LineWidth', 1.5)
    
    xlabel("Difference in interference")
    ylabel("Proportion")
    title("Distribution of difference (r-l) in interference (sp-si)")
    legend([{'Normalized histogram'}, {'Mean difference'}])
    
    [H, P, CI, STATS] = ttest(diff_diff_rightleft, 0);
    t_text_diffdiff = ['t(' num2str(STATS.df) ')=' num2str(STATS.tstat) ' p=' num2str(P)];
    disp("DIFF DIFF :" + t_text_diffdiff);
    
    x_pos = min(x);
    y_pos = max(n/sum(n)) * 0.9;
    text(x_pos, y_pos, t_text_diffdiff, 'FontSize', 10, 'FontWeight', 'bold');
    
    %% --- Extra t-tests ---
    [H, P, CI, STATS] = ttest(diff_right, 0);
    disp("DIFF RIGHT: t(" + num2str(STATS.df) + ")=" + num2str(STATS.tstat) + " p=" + num2str(P));
    
    [H, P, CI, STATS] = ttest(diff_left, 0);
    disp("DIFF LEFT : t(" + num2str(STATS.df) + ")=" + num2str(STATS.tstat) + " p=" + num2str(P));
    
    %% --- Split handedness ---
    right_handed_diffdiff = diff_diff_rightleft(num(:, 2)==1);
    left_handed_diffdiff  = diff_diff_rightleft(num(:, 2)==2);
    
    %% --- 2. Bar: handedness ---
    nexttile
    nexttile
    [H, P, CI, STATS] = ttest2(right_handed_diffdiff, left_handed_diffdiff);
    t2_text = ['t(' num2str(STATS.df) ')=' num2str(STATS.tstat) ' p=' num2str(P)];
    
    disp("RIGHTvsLEFThanded DIFF DIFF: " + t2_text);
    
    data = [mean(right_handed_diffdiff), mean(left_handed_diffdiff)];
    hold all
    
    b = bar([1, 2], data);
    hold on
    title("Mean interference for right vs left handed participants")
    errorbar([1, 2], data, [std(right_handed_diffdiff) std(left_handed_diffdiff)], ...
        'k', 'LineStyle', 'none')
    
    set(gca, 'XTick', [1 2], 'XTickLabel', {'Right', 'Left'})
    legend({'Mean interference'}, 'Location', 'best')
    
    x_pos = mean(xlim);
    y_pos = max(data + [std(right_handed_diffdiff) std(left_handed_diffdiff)]) * 1.15;
    text(x_pos, y_pos, t2_text, 'HorizontalAlignment', 'center', ...
        'FontSize', 10, 'FontWeight', 'bold');
    
    %% --- 3. Histogram: handedness ---
    nexttile
    [n1, x1] = hist(right_handed_diffdiff, 25);
    plot(x1, n1/sum(n1), 'LineWidth', 2)
    hold on
    plot([mean(right_handed_diffdiff) mean(right_handed_diffdiff)], [0 max(n1/sum(n1))], '--', 'LineWidth', 1.5)
    
    [n2, x2] = hist(left_handed_diffdiff, 25);
    plot(x2, n2/sum(n2), 'LineWidth', 2)
    plot([mean(left_handed_diffdiff) mean(left_handed_diffdiff)], [0 max(n2/sum(n2))], '--', 'LineWidth', 1.5)
    
    xlabel("Difference in interference")
    ylabel("Proportion")
    title("Distribution (right vs left handed)")
    legend({'Right handed','Right mean','Left handed','Left mean'})
    
    x_pos = min([x1 x2]);
    y_pos = max([n1/sum(n1) n2/sum(n2)]) * 0.9;
    text(x_pos, y_pos, t2_text, 'FontSize', 10, 'FontWeight', 'bold');
    
    %% --- Split sex (FIXED) ---
    female_mean = overall_mean_time(num(:, 1)==2);
    male_mean   = overall_mean_time(num(:, 1)==1);
    
    %% --- 4. Bar: sex ---
    nexttile
    [H, P, CI, STATS] = ttest2(female_mean, male_mean);
    t2_text_sex = ['t(' num2str(STATS.df) ')=' num2str(STATS.tstat) ' p=' num2str(P)];
    
    disp("FemalevsMale MEAN TIME: " + t2_text_sex);
    
    data = [mean(female_mean), mean(male_mean)];
    title("Mean time (female vs male)")
    hold all
    
    b = bar([1, 2], data);
    hold on
    errorbar([1, 2], data, [std(female_mean) std(male_mean)], ...
        'k', 'LineStyle', 'none')
    
    set(gca, 'XTick', [1 2], 'XTickLabel', {'Female', 'Male'})
    legend({'Mean time'}, 'Location', 'best')
    
    x_pos = mean(xlim);
    y_pos = max(data + [std(female_mean) std(male_mean)]) * 1.15;
    text(x_pos, y_pos, t2_text_sex, 'HorizontalAlignment', 'center', ...
        'FontSize', 10, 'FontWeight', 'bold');
    
    %% --- 5. Histogram: sex (FIXED) ---
    nexttile
    [n1, x1] = hist(female_mean, 25);
    plot(x1, n1/sum(n1), 'LineWidth', 2)
    hold on
    plot([mean(female_mean) mean(female_mean)], [0 max(n1/sum(n1))], '--', 'LineWidth', 1.5)
    
    [n2, x2] = hist(male_mean, 25);
    plot(x2, n2/sum(n2), 'LineWidth', 2)
    plot([mean(male_mean) mean(male_mean)], [0 max(n2/sum(n2))], '--', 'LineWidth', 1.5)
    
    xlabel("Mean time")
    ylabel("Proportion")
    title("Distribution (female vs male)")
    legend({'Female','Female mean','Male','Male mean'})
    
    x_pos = min([x1 x2]);
    y_pos = max([n1/sum(n1) n2/sum(n2)]) * 0.9;
    text(x_pos, y_pos, t2_text_sex, 'FontSize', 10, 'FontWeight', 'bold');