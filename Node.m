classdef Node
    % An node in a search tree. Contains a pointer to the parent (the node
    % that this is a successor of) and ot the actual state for this node.
    % Note that if a state is arrived at by two paths, then there are two
    % nodes with the same state. Also includes the action that got us to
    % this state, and the total path_cost (also known as g) to reach the
    % node.
    
    properties 
        state
        parent Node
        action
        depth int32
        path_cost double = 0
    end
    
    methods
        function obj = Node(state, parent, action, path_cost)
            % Constructor for Node class. Sets default vaules for parent,
            % actoion and path_cost in case they are missing.
            if nargin == 0
                error('Wrong number of input arguments.')
            elseif nargin == 1
                obj.state = state;
                obj.parent = Node.empty;
                obj.action = {};
                obj.path_cost = 0;
            elseif nargin == 2
                obj.state = state;
                obj.parent = parent;
                obj.action = {};
                obj.path_cost = 0;
            elseif nargin == 3
                obj.state = state;
                obj.parent = parent;
                obj.action = action;
                obj.path_cost = 0;
            else
                obj.state = state;
                obj.parent = parent;
                obj.action = action;
                obj.path_cost = path_cost;
            end
            
            if isempty(obj.parent)
                obj.depth = 0;
            else
                obj.depth = parent.depth + 1;
            end
        end
        
        function child_nodes = expand(obj, problem)
            % List the nodes reachable in one step from this node.
            child_nodes = {};
            problem_actions = problem.actions(obj.state);
            for i = 1: size(problem_actions, 2)
                child_nodes{1, end+1} = obj.child_node(problem, ...
                    problem_actions{1, i});
            end
        end
        
        function next_node = child_node(obj, problem, action)
            % Given the problem and the action taken result the child node
            next_state = problem.result(obj.state, action);
            next_node = Node(next_state, obj, action, problem.path_cost(...
                obj.path_cost, obj.state, action, next_state));
        end
        
        function solution = solution(obj)
            % Return the sequence of actions to go from the root to this
            % node.
            solution = {};
            path_to_solution = obj.path();
            for i = 1: size(path_to_solution, 2)
                solution{1, end+1} = path_to_solution{1, i}.action;
            end
        end
        
        function path_back = path(obj)
            % Return a list of nodes forming the path from the root to this
            % node.
            node = obj;
            % could optimize length of path back according to the node's
            % depth
            path_back = {};
            while ~isempty(node)
                path_back{1, end+1} = node;
                node = node.parent;
            end
            path_back = fliplr(path_back);
        end
    end
end
