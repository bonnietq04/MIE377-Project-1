function [mu, Q] = OLS_FamaFrench(returns, factRet)
    % OLS function using the first three factors from factRet (Mkt_RF, SMB, HML)

    % Extract first three factors
    selectedFactors = factRet(:, 1:3);  % Select Mkt_RF, SMB, and HML

    % Number of observations
    T = size(selectedFactors, 1);

    % Data matrix with intercept
    X = [ones(T,1) selectedFactors];

    % Regression coefficients
    B = (X' * X) \ X' * returns;

    % Separate B into alpha and betas
    a = B(1,:)';     % Intercept (alpha)
    V = B(2:end,:)'; % Betas (for three factors)

    % Residual variance
    ep       = returns - X * B; % Errors
    sigma_ep = 1/(T - size(X,2)) .* sum(ep .^2, 1); % Variance of residuals
    D        = diag(sigma_ep);  % Diagonal matrix

    % Factor expected return and variance
    f_bar = mean(selectedFactors, 1);  % Mean return of selected factors
    F     = cov(selectedFactors);      % Covariance matrix of selected factors

    % Asset expected returns and covariance matrix
    mu = a + V * f_bar';   % Expected return
    Q  = V * F * V' + D;  % Covariance matrix

    % Ensure symmetry for numerical stability
    Q = (Q + Q') / 2;
end
