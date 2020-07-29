function [solutions, t] = depth_limited_search_all(problem, limit)
    % Depth limited search function based on Artificial Intelligence: A
    % Modern Approach textbook. Differs from the one found in the books
    % repo in the sense that stores all the solutions that are found. So
    % the tree is exhausted at any case.
    
    if nargin == 1
        limit = 50;
    end
    
    solutions = {};
   
    function result = recursive_dls(node, problem, limit)
        % Recursive part of depth limited search. cutoff takes value true
        % when a branch is exhaisted or 0 otherwise
        
        if problem.goal_test(node.state)
%             result = node;
            solutions{end+1, 1} = node;
        end
        
        if limit == 0
            result = 'cutoff';
        else
            cutoff_occured = false;
            childs = node.expand(problem);
            for i = 1: size(childs, 2)
                child = childs{1, i};
                result = recursive_dls(child, problem, limit-1);
                if isa(result, 'char') & strcmp(result, 'cutoff')
                    cutoff_occured = true;
                end
            end
            if cutoff_occured result = 'cutoff'; else result = []; end
        end
    end
    
    t = recursive_dls(Node(problem.initial), problem, limit);
    
end


