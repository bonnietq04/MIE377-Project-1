%{
function x = Project1_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement your algorithmic asset management
    % strategy. You can modify this function, but you must keep the inputs
    % and outputs consistent.
    %
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)
    %
    % An example of an MVO implementation with OLS regression is given
    % below. Please be sure to include comments in your code.
    %
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------

    % Example: subset the data to consistently use the most recent 3 years
    % for parameter estimation
    returns = periodReturns(end-60:end,:);
    factRet = periodFactRet(end-60:end,:);
    
    % Example: Use an OLS regression to estimate mu and Q
    [mu, Q] = OLS(returns, factRet);
    
    % Example: Use MVO to optimize our portfolio
    x = MVO(mu, Q); 
    

    %----------------------------------------------------------------------
    end 
    %} 

function x = Project1_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement an optimized algorithmic trading strategy
    % using a Mean-Variance Optimization (MVO) framework with factor models (OLS).
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUT: x (optimized portfolio weights)
    
    % Define estimation period (most recent 3 years for calibration)
    returns = periodReturns(max(1, end-59):end, :);
    factRet = periodFactRet(max(1, end-59):end, :);

    
    % Estimate expected returns and covariance using OLS
    [mu, Q] = OLS(returns, factRet);
    
    % Optimize portfolio using MVO Model B (Maximize Return with Variance Constraint)
    x = MaxMVO(mu, Q, x0); % for Max Return MVO Model 
    
end
