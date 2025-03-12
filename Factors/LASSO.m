function selectedFactors = LASSO(returns, factRet)
    % LASSO Regression for factor selection based on coefficient shrinkage
    
    [n, p] = size(factRet); % n = observations, p = factors
    
    % Data matrix with intercept
    X = [ones(n, 1), factRet]; % Add intercept
    y = mean(returns, 2); % Target is average stock return
    
    % Standardize predictors (excluding intercept)
    X(:, 2:end) = (X(:, 2:end) - mean(X(:, 2:end))) ./ std(X(:, 2:end));
    
    % Automatically determine lambda using cross-validation
    [B, FitInfo] = lasso(X, y, 'CV', 10); % 10-fold cross-validation
    bestLambdaIndex = FitInfo.Index1SE; % Choose lambda within 1 standard error of min MSE
    bestB = B(:, bestLambdaIndex); % Best coefficients
    
    % Select factors based on nonzero coefficients
    selectedFactors = find(bestB(2:end) ~= 0); % Exclude intercept
end
