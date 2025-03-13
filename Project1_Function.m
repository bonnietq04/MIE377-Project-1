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

    % Example: subset the data to consistently use the most recent 5 years
    % Define estimation period (most recent 5 years for calibration)
    returns = periodReturns(max(1,end-59):end,:);
    factRet = periodFactRet(max(1,end-59):end,:);
    %returns (isnan(returns)) = 0;
    %factRet(isnan(factRet) | isinf(factRet)) = 0;

    % UNCOMMENT TO RUN BSS
    %selectedFactors = BSS(returns, factRet)
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));

    % UNCOMMENT TO RUN Ridge Regression
    selectedFactors = RidgeRegression(returns, factRet);
    [mu, Q] = OLS(returns, factRet(:, selectedFactors));


    % UNCOMMENT TO RUN LASSO
    %selectedFactors = LASSO(returns, factRet)
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));

    
    % UNCOMMENT TO RUN CAPM OLS
    %[mu, Q] = OLS_CAPM(returns, factRet);

    % UNCOMMENT TO RUN FAMA FRENCH OLS
    %[mu, Q] = OLS_FamaFrench(returns, factRet);
    
    % comment this out to run average / uncomment to run factors
    [mu, Q] = OLS(returns, factRet);
    %disp(mu);

    % uncomment to run average
    %mu = mean(periodReturns)';  % n x 1
    %Q  = cov(periodReturns);    % n x n
    
    % Example: Use MVO to optimize our portfolio
    x = RobustMVO(mu, Q, x0);

    %----------------------------------------------------------------------
end
