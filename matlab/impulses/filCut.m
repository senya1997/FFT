function [data_cut] = filCut(data, cut_border) % "cut_border" in "%"

fprintf('\ncut filter...\n');
max_data = max(data);
ind_sign = 1;

for i = 1:length(data)
    if(data(i) >= cut_border*max_data/100) % cut impulse if amplitude smaller then "cut_border"% from max
        ind_sign = i;
    end
end

data_cut = data(1:ind_sign);
fprintf('complete\n\n');