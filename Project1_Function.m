function x = Project1_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement an optimized algorithmic trading strategy
    % using a Mean-Variance Optimization (MVO) framework with factor models (OLS).
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUT: x (optimized portfolio weights)
    
    % Define estimation period (most recent 3 years for calibration)
    returns = periodReturns(max(1, end-59):end, :);
    factRet = periodFactRet(max(1, end-59):end, :);
    
    % UNCOMMENT TO RUN BSS
    %selectedFactors = BSS(returns, factRet)
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));

    % UNCOMMENT TO RUN Ridge Regression
    selectedFactors = RidgeRegression(returns, factRet);
    [mu, Q] = OLS(returns, factRet(:, selectedFactors));


    % UNCOMMENT TO RUN LASSO
    %selectedFactors = LASSO(returns, factRet)
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));

    % UNCOMMENT TO RUN REGULAR OLS
    %[mu, Q] = OLS(returns, factRet);

    
    % UNCOMMENT TO RUN CAPM OLS
    %[mu, Q] = OLS_CAPM(returns, factRet);

    % UNCOMMENT TO RUN FAMA FRENCH OLS
    %[mu, Q] = OLS_FamaFrench(returns, factRet);
    
    % Optimize portfolio using MVO Model B (Maximize Return with Variance Constraint)
    x = MVO(mu, Q, x0); % for Max Return MVO Model 
    
end
