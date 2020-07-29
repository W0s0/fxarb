classdef Problem
    % The abstract class for a formal problem. You should subclass this and
    % implement the methods actions and result, and possibly the
    % constructor, goal_test, 
    
    properties
        initial
        goal
    end
    
    methods
        function obj = Problem(initial, goal)
            % The constructorspecifies the initial state,  and possibly a
            % goal state, if there is a unique goal. Your subclass'
            % constructor can add other arguments.
            % goal should a (1, n) or (n, 1) vector.
            if nargin == 1
                obj.initial = initial;
                obj.goal = {};
            elseif nargin == 0
                error('At least initial state should be specified.')
            else
                obj.initial = initial;
                obj.goal = goal;
            end
        end
        
        function actions(obj, state)
            % Return the actions that can be executed in the given state.
            error('NotImplementedError')
        end
        
        function result(obj, state, action)
            % Return the state that results from executing the given state.
            % The action be one of self.actions(state).
            error('NotImplementedError')
        end
        
        function goal_reached = goal_test(obj, state)
            if ~isempty(obj.goal)
                goal_reached = ismember(state, inobj.goal);
            else
                error('Goal has not been specified.')
            end
        end
        
        function cost = path_cost(obj, c, state1, action, next_state)
            % Return the cost of a solution path that arrives at state2 
            % from state1 via action, assuming cost c to get up to state1. 
            % If the problem is such that the path doesn't matter, this
            % function will only look at state2. If the path does matter, 
            % it will consider c and maybe state1 and action. The default 
            % method costs 1 for every step in the path.
            cost = c + 1;
        end
        
        function value(obj, state)
            % For optimization problems, each state has a value.
            error('NotImplementedError')
        end
    end
end

