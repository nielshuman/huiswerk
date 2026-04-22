clear all, close all, clc

data1 = randn(1, 1000);
data2 = randn(1, 1000) + 2;

figure;
for d = {data1, data2}
    histogram(d{1}, 30); hold on;
    xline(mean(d{1}), '--k', 'LineWidth', 2);
end
hold off;

hitrates = []; falserates = [];
for criterion = sort([data1, data2], 'descend')
    hr = length(find(data2 > criterion)) / length(data2);
    far = length(find(data1 > criterion)) / length(data1);
    
    hitrates(end+1) = hr;
    falserates(end+1) = far;
end

figure;
plot(falserates, hitrates, '-'); hold on
set(gca, 'xlim', [0, 1], 'ylim', [0, 1]);
area = trapz(falserates, hitrates);
