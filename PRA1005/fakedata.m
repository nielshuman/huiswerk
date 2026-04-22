close all

data = randn(1, 1000);
data2 = randn(1, 1000) + 0.3;

[n1, x1] = hist(data, 25);
[n2, x2] = hist(data2, 25);
mean1 = mean(data);
mean2 = mean(data2);
figure
tiledlayout(2,2)

% Tile 1
nexttile
hold on
plot(x1, n1/sum(n1), 'LineWidth', 2)
plot(x2, n2/sum(n2), 'LineWidth', 2)

plot([mean(data) mean(data)], [0 max(n1/sum(n1))], '--', 'LineWidth', 1.5)
plot([mean(data2) mean(data2)], [0 max(n2/sum(n2))], '--', 'LineWidth', 1.5)

title('Data distributions')
xlabel('Value')
ylabel('Proportion')
legend({'data1','data2','mean1','mean2'})
hold off

[H, P, CI, STATS] = ttest(data, 0);

% Tile 2
nexttile
bar([mean(data) mean(data2)])
ylabel('Mean')

% Tile 3
nexttile

% Tile 4
nexttile
