function [mu, Q] = PCA(returns, p)
% Returns mu and Q estimates based on PCA-OLS
% 
% Inputs:
%   returns - T x n matrix of asset returns
%   p       - number of principal components to extract
%
% Outputs:
%   mu - n x 1 expected returns
%   Q  - n x n covariance matrix
    if istable(returns)
        returns = table2array(returns); % Convert table to numeric
    end

    [T, n] = size(returns);

    %% PCA

    % Compute mean return vector
    r_bar = mean(returns, 1);                  % 1 x n
    R_bar = returns - repmat(r_bar, T, 1);     % Centered returns

    % Estimate biased covariance matrix
    Q_biased = (1/T) * ((R_bar') * R_bar);       % n x n

    % Eigen decomposition
    [V, D] = eig(Q_biased);                    % Columns of V are eigenvectors

    % Sort eigenvalues (and eigenvectors) in descending order
    [~, idx] = sort(diag(D), 'descend');
    V = V(:, idx);

    % Construct principal component scores (T x n)
    P = R_bar * V;

    % Select top p components
    P1 = real(P(:, 1:p));                      % T x p
    factRet = P1;

    %% OLS

    [T, p] = size(factRet); 
    
    % Data matrix
    X = [ones(T,1) factRet];
    
    % Regression coefficients
    B = (X' * X) \ X' * returns;
    
    % Separate B into alpha and betas
    a = B(1,:)';     
    V = B(2:end,:); 
    
    % Residual variance
    ep       = returns - X * B;
    sigma_ep = 1/(T - p - 1) .* sum(ep .^2, 1);
    D        = diag(sigma_ep);
    
    % Factor expected returns and covariance matrix
    f_bar = mean(factRet,1)';
    F     = cov(factRet);
    
    % Calculate the asset expected returns and covariance matrix
    mu = a + V' * f_bar;
    Q  = V' * F * V + D;
    
    % Sometimes quadprog shows a warning if the covariance matrix is not
    % perfectly symmetric.
    Q = (Q + Q')/2;
end