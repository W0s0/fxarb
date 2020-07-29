classdef RoundTripTrade < Problem
    % Problem subclass that implements question 1. Given the bid quotation
    % table, agent should find the the profitable trades a.k.a. arbitrage
    % opportunities.
    
    properties
        quotes table
    end
    
    methods
        function obj = RoundTripTrade(starting_curr, quotation_matrix)
            % Constructs initial and goal state and initializes Problem
            % instance.
            % Assumes quotation_matrix is a table that contains the quotes
            % and has named row names.
            % Inputs:
            %   initial: [char] The starting currency.
            %   quotation_matrix: [table] Contains the fx quotes including
            %   row and collumn names.
            
            % TODO: check if initial is well defined based on the quotation
            % matrix
            
            obj = obj@Problem({1, starting_curr}, {1, starting_curr});
            
            obj.quotes = quotation_matrix;
        end
        
        function actions = actions(obj, state)
            % Returns the actions as a cell array. Each action is a cell
            % array of char elements {term, base}.
            
            base = state{1, 2};
            fx = obj.quotes.Properties.RowNames';
            % Do not include the option to convert to the starting currency
            fx(:, all(char(fx{:}) == obj.goal{1, 2}, 2)) = [];
            % Do not include the option to convert to the current currency
            fx(:, all(char(fx{:}) == base, 2)) = [];
            
            actions = cell(size(fx));
            for i = 1: size(actions, 2)
                actions{1, i} = {fx{1, i}, base};
            end
        end
        
        function new_state = result(obj, state, action)
            new_state = {state{1, 1} * ...
                obj.quotes{action{1, 1}, action{1, 2}}, action{1, 1}};
        end
        
        function goal_reached = goal_test(obj, state)
            % Goal test: Convert to initial currency and check if the
            % amount is greater than 1. Note that the obj.goal is the same
            % as obj.initial{1, 2}.

            if obj.value(state) > obj.goal{1, 1}
                goal_reached = true;
            else
                goal_reached = false;
            end
        end
        
        function cost = path_cost(obj, c, state1, action, next_state)
            % This problem does not have a cost function.
            cost = 0;
        end
        
        function val = value(obj, state)
            if strcmp(state{1, 2}, obj.goal{1, 2})
                val = state{1, 1};
            else
                val = state{1, 1} * obj.quotes{obj.goal{1, 2}, state{1, 2}};
            end
        end
    end
end
