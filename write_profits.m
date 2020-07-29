function t = write_profits(profits, filename, sheet_name)
    % Writes the profits at a .xlsx file given the filename and the sheet
    % name.
    
    sort_profits_by_depth = utils('sort_profits_by_depth');
    
    % higher order filtered profits are sorted because of filtering.
    profits = sort_profits_by_depth(profits);
    
    max_depth = size(profits{end, 1}, 2);
    
    % predefine size
    profits_c = cell(size(profits, 1), 1 + max_depth);
    for i = 1: size(profits, 1)
        profits_c{i, 1} = profits{i, 2};
        profits_c(i, 2:(1+size(profits{i, 1}, 2))) = profits{i, 1};
    end
    
    % create labels:
    collumn_names = cell(1, max_depth + 1);
    collumn_names(1, 1:2) = {'Profit', 'Starting_Currency'};
    
    for i = 1:max_depth-1
        collumn_names{1, 2+i} = ['Currency_' num2str(i)];
    end
    
    % convert cell to table
    
    t = cell2table(profits_c);
    t.Properties.VariableNames = collumn_names;
    
    if nargin == 3
        writetable(t, filename,'Sheet', sheet_name);
    elseif nargin == 2
        writetable(t, filename)
    end
end