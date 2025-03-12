function selectedFactors = RidgeRegression(returns, factRet, threshold)
    % Ridge Regression with automatic lambda selection and factor selection based on coefficient magnitude
    
    [n, p] = size(factRet); % n = observations, p = factors
    
    % Data matrix with intercept
    X = [ones(n, 1), factRet]; % Add intercept
    y = mean(returns, 2); % Target is average stock return
    
    % Automatically determine lambda (heuristic based on variance of factors)
    lambda = mean(var(factRet)) * 0.1; % Scale by 0.1 as a regularization heuristic
    
    % Ridge Regression solution
    I = eye(size(X, 2));
    I(1,1) = 0; % Do not regularize intercept term
    
    % Compute Ridge Regression coefficients
    ridgeCoeffs = (X' * X + lambda * I) \ (X' * y);
    
    % Select factors based on coefficient magnitude
    selectedFactors = find(abs(ridgeCoeffs(2:end)) > threshold); % Exclude intercept
end
