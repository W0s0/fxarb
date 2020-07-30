# FX Arbitrage - From a Search Problem Perspective
This project opts to create a framework for searching for FX (Foreign Exchange) arbitrage opportunities by utilizing 
search problem theory found in the textbook Artificial Intelligence: A Modern Approach.

In order to understand the code you can either read the report "FX-Arbitrage-From a Search Problem Perspective.pdf"
or take look at the mlx files that are included in the repo.

A general description of each .m file follows:
* Problem.m: matlab class file that contains the Problem parents class
* Node.m: matlab class file that contains the definition of the Node class
* RoundTripTrade.m: matlab class file that inherits that Problem class and defines the problem of searching for a 
triangular arbitrage opportunity
* OneWatTripTrade.m: matlab class file that inherits the RoundTripTrade class in order to define the problem of searching 
for one-way-arbitrage opportunities
* depth_limited_search.m: matlab function file that implement the depth limited search algorithm
* depth_limited_search_all.m: matlab function file that twists depth_limited_search function  in a way that the algorithm performs 
exhaustive search and stores all solutions
* utils.m: matlab function file that contains the utility functions used to perform the solution filtering and debugging
operations
* write_profits.m: matlab function file that is used to write the results from the mlx files to xlx formal.

