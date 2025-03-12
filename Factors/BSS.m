function selectedFactors = BSS(returns, factRet)
    % Best Subset Selection for factor models
    
    [n, p] = size(factRet); % n = observations, p = factors
    bestScore = Inf;
    selectedFactors = [];

    % Loop through all possible subsets of factors
    for k = 1:p  % Number of selected factors
        subsets = nchoosek(1:p, k); % Generate all subsets of size k
        
        for i = 1:size(subsets, 1) % Iterate through subsets
            factors = subsets(i, :);
            X = [ones(n, 1), factRet(:, factors)]; % Add intercept
            y = mean(returns, 2); % Target is average stock return
            
            % Run OLS regression
            b = (X' * X) \ (X' * y);
            residuals = y - X * b;
            
            % Compute Bayesian Information Criterion (BIC)
            sigma2 = var(residuals);
            bic = n * log(sigma2) + length(factors) * log(n);
            
            % Store best subset (lower BIC is better)
            if bic < bestScore
                bestScore = bic;
                selectedFactors = factors;
            end
        end
    end
end
