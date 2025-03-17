function x = Project1_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement your algorithmic asset management
    % strategy. You can modify this function, but you must keep the inputs
    % and outputs consistent.
    %
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)s
    %
    % An example of an MVO implementation with OLS regression is given
    % below. Please be sure to include comments in your code.
    %
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------

    % Example: subset the data to consistently use the most recent 5 years
    % Define estimation period (most recent 5 years for calibration)
    returns = periodReturns(max(1,end-59):end,:);
    factRet = periodFactRet(max(1,end-59):end,:);
 
    % Estimate mu and Q using sample mean and covariance 
    mu = mean(periodReturns)';  % n x 1
    Q  = cov(periodReturns);    % n x n
    
    % Use RobustMVO to optimize our portfolio
    x = RobustMVO(mu, Q, x0);

    %----------------------------------------------------------------------
end
