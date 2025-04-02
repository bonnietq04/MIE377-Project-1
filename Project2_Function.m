function x = Project2_Function(periodReturns, periodFactRet, x0) % add riskFree in main file as well 


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
    % UNcomment to run sharpe ratio
    %rfWindow = riskFree(max(1,end-35):end,:);
    %r_f = mean(rfWindow, 'omitnan');
    %r_f = table2array(r_f)


    %most recent 3 years
    %returns = periodReturns(end-35:end,:);
    %factRet = periodFactRet(end-35:end,:);

    %returns (isnan(returns)) = 0;
    %factRet(isnan(factRet) | isinf(factRet)) = 0;

    % UNCOMMENT TO RUN BSS
    %selectedFactors = BSS(returns, factRet)
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));

    % UNCOMMENT TO RUN Ridge Regression
    %selectedFactors = RidgeRegression(returns, factRet);
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));


    % UNCOMMENT TO RUN LASSO
    %selectedFactors = LASSO(returns, factRet)
    %[mu, Q] = OLS(returns, factRet(:, selectedFactors));

    
    % UNCOMMENT TO RUN CAPM OLS
    %[mu, Q] = OLS_CAPM(returns, factRet);

    % UNCOMMENT TO RUN FAMA FRENCH OLS
    %[mu, Q] = OLS_FamaFrench(returns, factRet);
    
    % UNCOMMENT TO RUN OLS
    %[mu, Q] = OLS(returns, factRet);
    %disp(mu);

    % UNCOMMENT TO RUN AVERAGE
    %mu = mean(periodReturns)';  % n x 1
    %Q  = cov(periodReturns);    % n x n

    %UNCOMMENT TO RUN PCA
    [T, n_assets] = size(returns);

    sharpeRatios = zeros(1, n_assets);

    % Loop through PCA components to find optimal number of components
    for p = 1:n_assets
        [mu_temp, Q_temp] = PCA(returns, p);

        % Obtain temporary portfolio weights using Risk Parity
        x_temp = RiskParity(mu_temp,Q_temp);

        % Calculate cumulative portfolio value starting at 1
        portfValue_temp = cumprod([1; returns * x_temp + 1]);

        % Calculate portfolio returns directly (no r_f)
        portfRets_temp = portfValue_temp(2:end) ./ portfValue_temp(1:end-1) - 1;

        % Sharpe ratio consistent with main script (no rf subtraction here)
        sharpeRatios(p) = (geomean(portfRets_temp + 1) - 1) / std(portfRets_temp);
    end

    % Optimal PCA components (highest Sharpe)
    [~, optimal_p] = max(sharpeRatios);


    % Final PCA estimation with optimal p
    [mu, Q] = PCA(returns, optimal_p);

    % x = CVaR_Optimization(returns, factRet, 0.95);
    %if you want to use factor model, replace returns with mu

    % Final weights using Risk Parity
    x = RiskParity(mu,Q);
    

    %----------------------------------------------------------------------
end


