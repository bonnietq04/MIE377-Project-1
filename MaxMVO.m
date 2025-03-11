%{
function  x = MVO(mu, Q)
    
    % Use this function to construct an example of a MVO portfolio.
    %
    % An example of an MVO implementation is given below. You can use this
    % version of MVO if you like, but feel free to modify this code as much
    % as you need to. You can also change the inputs and outputs to suit
    % your needs. 
    
    % You may use quadprog, Gurobi, or any other optimizer you are familiar
    % with. Just be sure to include comments in your code.

    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------
    
    % Find the total number of assets
    n = size(Q,1); 
    
    % Set the target as the average expected return of all assets
    targetRet = mean(mu);
    
    % Disallow short sales
    lb = zeros(n,1);

    % Add the expected return constraint
    A = -1 .* mu';
    b = -1 * targetRet;

    %constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    x = quadprog( 2 * Q, [], A, b, Aeq, beq, lb, [], [], options);
    
    %----------------------------------------------------------------------
    
end 
%} 
function x = MaxMVO(mu, Q, x0)
    
    % Implements Mean-Variance Optimization (MVO) Model B: Maximize Return with Target Variance Constraint
    % INPUTS: mu (expected returns), Q (covariance matrix)
    % OUTPUT: x (optimized portfolio weights)
    
    % Define number of assets
    n = length(mu);
  
    
    % Define optimization problem
    mu(isnan(mu)) = 0; % Replace NaNs in expected returns
    Q(isnan(Q)) = 0; % Replace NaNs in covariance matrix
    
    % Constraints: fully invested portfolio and target variance
    Aeq = ones(1,n);
    beq = 1;
    lb = zeros(n, 1);
    
      % Define the variance constraint function
    function [c, ceq] = riskConstraint(x)
        c = x' * Q * x; % c <= 0 ensures variance is within limit
        ceq = [];
    end

    % Solve using fmincon
    options = optimoptions('fmincon', 'Display', 'off');
    x = fmincon(@(x) -mu' * x, ones(n,1)/n, [], [], Aeq, beq, lb, [], @riskConstraint, options);
end

%%