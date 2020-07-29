function solutions = depth_limited_search(problem, limit)
    % Depth limited search function based on Artificial Intelligence: A
    % Modern Approach textbook.
    
    if nargin == 1
        limit = 50;
    end
    
    function result = recursive_dls(node, problem, limit)
        % Recursive part of depth limited search. cutoff takes value true
        % when a branch is exhaisted or 0 otherwise
        
        if problem.goal_test(node.state)
            result = node;
        elseif limit == 0
            result = 'cutoff';
        else
            cutoff_occured = false;
            childs = node.expand(problem);
            for i = 1: size(childs, 2)
                child = childs{1, i};
                result = recursive_dls(child, problem, limit-1);
                if isa(result, 'char') & strcmp(result, 'cutoff')
                    cutoff_occured = true;
                elseif ~isempty(result)
                    % Node passed goal_test
                    return
                end
            end
            if cutoff_occured result = 'cutoff'; else result = []; end
        end
    end
    
    solutions = recursive_dls(Node(problem.initial), problem, limit);
    
end


