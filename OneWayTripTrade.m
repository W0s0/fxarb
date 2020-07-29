classdef OneWayTripTrade < RoundTripTrade
    % Simulates the search problem of finding a one way trip arbitrage
    % opportunity given the fx bid quotes.
    
    methods
        function obj = OneWayTripTrade(starting_curr, ending_curr, quotation_matrix)
            % Constructs initial and goal state and initializes Problem
            % instance.
            % Assumes quotation matrix is a table that contains the quotes
            % and has named row names.
            % we begin.
            % Inputs:
            %   initial: [char] The starting currency.
            
            obj = obj@RoundTripTrade(starting_curr, quotation_matrix);
            
            % Modify Goal for OneWayTripTrade
            obj.goal = ...
                {obj.quotes{ending_curr, starting_curr}, ending_curr};
        end
    end
end

