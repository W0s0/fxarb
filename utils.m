%% Global namespace handler
% Contains utility functions that handle solution sorting, filtering and
% other functionalities. Also contains debugging functions.

function util_func = utils(func)
    % This function makes the following utility function accessible to the 
    % directories global scope. If you need one function from this file
    % just add a function handler for it.
    
    if strcmp(func, 'extract_profit_all')
        util_func = @extract_profit_all;
    elseif strcmp(func, 'profits_group_by')
        util_func = @profits_group_by;
    elseif strcmp(func, 'pretty_print_grouped_profits')
        util_func = @pretty_print_grouped_profits;
    elseif strcmp(func, 'pretty_print_profits_oneway')
        util_func = @pretty_print_profits_oneway;
    elseif strcmp(func, 'profits_grouped2curr_buckets')
        util_func = @profits_grouped2curr_buckets;
    elseif strcmp(func, 'profits_depth_filter')
        util_func = @profits_depth_filter;
    elseif strcmp(func, 'filter_oneway_profits')
        util_func = @filter_oneway_profits;
    elseif strcmp(func, 'sort_profits_by_depth')
        util_func = @sort_profits_by_depth;
    else
        error('argument does not match any utility function')
    end
end

%% In global namespace

function profits = extract_profit_all(solutions, problem)
    % Extract profits from a solutions cell array where each element is a
    % node. Profits is a cell array of which each row consists of 2
    % elements: 
    %   1st element: cell array with the currencies of the round trip trade
    %   2nd element: profit of the roundtrip trade.
    
    n_nodes = size(solutions, 1);
    profits = cell(n_nodes, 2);
    
    for i = 1: n_nodes
       profit = extract_profit(solutions{i, 1}, problem);
       profits{i, 1} = profit{1, 1};
       profits{i, 2} = profit{1, 2};
    end
end

function profits_grouped = profits_group_by(profits)
    % Scans the profits table for the same triangles and group them in a
    % cell array of which:
    %   The first element is the currency combination
    %   The second element is a cell array of similar format of the profits
    %   input that only contains the same triangles. 
    %  
    % To be changed: The second element is a {1, n} cell array that
    % contains in each column a profit cell array. Indexing the grouped
    % profits element could be easier if the element was of the format    
    % {n, 3}. Change should be broadcasted to functions that use the
    % grouped version of profits such as the pretty_print utility
    % functions.
    
    sequences = extract_sequence_all(profits);
    profits_grouped = {};
    
    for i = 1: size(sequences, 1)
       profits_grouped{end+1, 1} = extract_quotes(sequences{i, 1});
       profits_grouped{end, 2} = 0;
       profits_grouped{end, 3} = cell.empty;
    end
    
    for i = 1:size(profits, 1)
       quotes = profits{i, 1};
       index = in_sequences([quotes{:}], sequences);
       if ~isempty(index)
           profits_grouped{index, 2} = profits{i, 2};

           % add the trade to the group.
           trades = profits_grouped{index, 3}; 
           trades{1, end+1} = profits(i, :);
           profits_grouped{index, 3} = trades;
       end
    end

end

function pretty_print_grouped_profits(profits_grouped, tm)
    % Pretty prints the grouped profits showing the triangle combinations 
    % and their repspective trades
    
    for i = 1: size(profits_grouped, 1)
        goal_curr = profits_grouped{i, 3}{1, 1}{1, 1}{1, 1};
        disp([num2str(i) '. Triangle: ' ...
            pretty_print_triangle(profits_grouped{i, 3}{1, 1}, goal_curr)])
        for j = 1: size(profits_grouped{i, 3}, 2)
            disp(['    ' num2str(i) '.' num2str(j) ' profit=' ...
                pretty_print_profit(profits_grouped{i, 3}{1, j}, ...
                                    profits_grouped{i, 3}{1, j}{1, 1}{1, 1},...
                                    tm)])
        end
    end
end

function pretty_print_profits_oneway(profits, goal_curr, tm)
    % Same with pretty_print_grouped_profits but for one way arbitrage.
    
    for i = 1:size(profits, 1)
        disp([num2str(i) '. Triangle: ' ...
            pretty_print_triangle(profits(i, :), goal_curr)])
        disp(['    profit=' ...
            pretty_print_profit(profits(i, :), ...
                                goal_curr, tm, true)])
    end
end

function buckets = profits_grouped2curr_buckets(profits_grouped, ...
    curr_buckets)
    % curr backets is a (1, n) cell array that contains the wanted
    % currencies on which we will summ the profits. currency bucket is
    % created only if the sum is not zero.
    
    function ind_curr = find_curr_ind(curr)
        ind_curr = [];
        
        for i = 1: size(profits_grouped, 1)
            if ismember(curr, profits_grouped{i, 1})
               ind_curr = [ind_curr i]; 
            end
        end
    end
    
    for j = 1: size(curr_buckets, 2)
        ind = find_curr_ind(curr_buckets{1, j});
        if ~isempty(ind)
            bucket = sum([profits_grouped{ind, 2}]);
            buckets.(curr_buckets{1, j}) = bucket;
            profits_grouped(ind, :) = [];
        end
    end
    
    if ~isempty(profits_grouped)
       error(['Input more than ' num2str(size(curr_buckets, 2)) ...
           ' or different currencies'])
    end
end

function profits_sorted = sort_profits_by_depth(profits)
    % Sorts the ungrouped profits by depth in a ascending order.
    
    function ind = depth_ind(profits, depth)
        ind = [];
        for i = 1: size(profits, 1)
            if size(profits{i, 1}, 2) - 1 == depth
                ind = [ind i];
            end
        end
    end

    profits_sorted = {};
    
    depth = 1;
    while ~isempty(profits)
        ind = depth_ind(profits, depth);
        profits_sorted = cat(1, profits_sorted, profits(ind, :));
        profits(ind, :) = [];
        depth = depth + 1;
    end
end

function profits_filtered = profits_depth_filter(profits)
    % Removes higher depth solutions if they contain inside them lower
    % depth solution triangles and produce less of a profit.
    
    profits = sort_profits_by_depth(profits);
    
    ind = [];
    
    for i = 1: size(profits, 1)
        if length(profits{i, 1}) == length(profits{end, 1})
            break
        end
        
        for j = size(profits, 1):-1:1
            if length(profits{i, 1}) == length(profits{j, 1})
                break
            end
            
            if contains([profits{j, 1}{:}], [profits{i, 1}{:}]) & profits{j, 2} < profits{i, 2}
                ind = [ind j];
            end
        end
    end
 
    % Drop higher depth trades that just cover the loss with the gains of a
    % lower depth one
    profits(ind, :) = [];
    
    profits = profits_group_by(profits);
    
    ind = [];
    for i = 1: size(profits, 1)
        if length(profits{i, 1}) > length(profits{i, 3})
            ind = [ind i];
        end
    end
    
    % Drop identical to previously rejected trades.
    profits(ind, :) = [];
    
    profits_filtered = profits;
end

function profits_oneway_filtered = filter_oneway_profits(profits)
    % Removes higher depth solutions if they contain inside them lower
    % depth solutions and produce less of a profit. 
    % Specific to one-way-arbitrage.

    profits = sort_profits_by_depth(profits);
    
    ind = []; 
    
    for i = 1: size(profits, 1)
        if length(profits{i, 1}) == length(profits{end, 1})
            break
        end
        
        for j = size(profits, 1):-1:1
            if length(profits{i, 1}) == length(profits{j, 1})
                break
            end
            
            if contains([profits{j, 1}{:}], [profits{i, 1}{:}]) & profits{j, 2} < profits{i, 2}
                ind = [ind j];
            end
        end
    end
 
    % Drop higher depth trades that just cover the loss with the gains of a
    % lower depth one
    profits(ind, :) = [];
    
    profits_oneway_filtered = profits;
end

%% outside global namespace

function profit = extract_profit(node, problem)
    % Returns cell array of whose elements are:
    %   1st element: cell array with the currencies of the round trip trade
    %   2nd element: profit of the roundtrip trade.
    
    p = {};

    function recursive_trade_extraction(node)
        if isempty(node)
            % Stop case. 
            return
        else
            p{1, end+1} = node.state{1, 2};
            recursive_trade_extraction(node.parent)
        end
    end

    profit = cell(1, 2);
    
    profit{1, 2} = problem.value(node.state)-problem.goal{1, 1};
    
    recursive_trade_extraction(node)
    p = fliplr(p);
    
    profit{1, 1} = p;
        
end

function sequence = extract_sequence(profit)
    % Extracts the currencies that compose a triangular arbitrage and
    % concatenates them.
    
    quotes = profit{:, 1};
    sequence = [quotes{:} quotes{:}];
end

function quotes = extract_quotes(sequence)
    % Extracts the quotes in a cell array format from a sequence that 
    % concerns a round-trip-trade.
    
    quotes = {};
    for i = 1: size(sequence, 2)
        if mod(i, 3) == 0
            quotes{1, end+1} = sequence(1, i-2:i);
        end
    end
    quotes = quotes(1, 1:size(quotes, 2)/2);
end

function index = in_sequences(member, sequences)
    % Check if 2 triangles of the same depth are the same given a triangle
    % sequence and a sequence as defined above.
    
    index = [];
    for i = 1: size(sequences, 1)
        sequence = sequences{i, 1};
        if contains(sequence, member) & ...
                length(member)*2 == length(sequence)
            
            index = [index i];
        end
    end
end

function sequences = extract_sequence_all(profits)
    % Extract the sequences of all the unique triangles of a profits cell
    % array.
    
    sequences = {};
    for i = 1: size(profits, 1)
        quotes = profits{i, 1};
        index = in_sequences([quotes{:}], sequences);
        if isempty(index)
            sequences{end+1, 1} = extract_sequence(profits(i, :));
        end
    end
end

function triangle = pretty_print_triangle(profit, goal_curr)
    % Pretty prints the currency combination of an arbitrage opportutinity.

    currencies = profit{1, 1};

    triangle = currencies{1, 1};
    for i = 2: size(currencies, 2)
        triangle = [triangle '-->' currencies{1, i}];
    end
    
    triangle = [triangle '-->' goal_curr];
end

function profit_str = pretty_print_profit(profit, goal_curr, tm, ...
    oneway)
    % Pretty prints the transactions of a round trip trade.

    if nargin == 3
        oneway = false;
    end
    
    profit_str = [num2str(1) profit{1, 1}{1, 1}];
    for i = 2: size(profit{1, 1}, 2)
        term = profit{1, 1}{1, i};
        base = profit{1, 1}{1, i-1};
        profit_str = [profit_str '*' num2str(tm{term, base}) term '/' base];
    end
    
    profit_str = [profit_str '*' num2str(tm{goal_curr, term}) goal_curr ...
        '/' term];
    
    if oneway
        term = goal_curr;
        base = profit{1, 1}{1, 1};
        profit_str = [profit_str '-' num2str(tm{term, base}) term '/' base];
    end
    profit_str = [profit_str '=' num2str(profit{1, 2}) goal_curr];
end
