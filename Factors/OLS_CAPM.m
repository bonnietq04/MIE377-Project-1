function [mu, Q] = OLS_CAPM(returns, factRet)
    % OLS function using only the first factor from factRet

    % Extract first factor column
    firstFactor = factRet(:,1);  % Select only the first factor

    % Number of observations
    T = size(firstFactor, 1);

    % Data matrix with intercept
    X = [ones(T,1) firstFactor];

    % Regression coefficients
    B = (X' * X) \ X' * returns;

    % Separate B into alpha and beta
    a = B(1,:)';     % Intercept (alpha)
    V = B(2,:)';     % Beta (for only one factor)

    % Residual variance
    ep       = returns - X * B; % Errors
    sigma_ep = 1/(T - 2) .* sum(ep .^2, 1); % Variance of residuals
    D        = diag(sigma_ep);  % Diagonal matrix

    % Factor expected return and variance
    f_bar = mean(firstFactor);  % Mean return of first factor
    F     = var(firstFactor);   % Variance of first factor

    % Asset expected returns and covariance matrix
    mu = a + V * f_bar;   % Expected return
    Q  = V * F * V' + D;  % Covariance matrix

    % Ensure symmetry for numerical stability
    Q = (Q + Q') / 2;
end
