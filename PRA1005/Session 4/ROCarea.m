function [area] = ROCarea(data1,data2)
    hitrates = []; falserates = [];
    for criterion = sort([data1, data2], 'descend')
        hr = length(find(data2 > criterion)) / length(data2);
        far = length(find(data1 > criterion)) / length(data1);
        
        hitrates(end+1) = hr;
        falserates(end+1) = far;
    end
    area = trapz(falserates, hitrates);
end