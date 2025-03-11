function x = MinMVO(mu, Q, x0)

    
    mu(isnan(mu)) = 0; % Replace NaNs in expected returns
    Q(isnan(Q)) = 0; % Replace NaNs in covariance matrix
    % Constraints
    lb = zeros(20, 1); % No short selling (weights >= 0)
    A = -mu'; % Ensure A has the right shape (1 × 20)
    b = -0.0025; % Minimum return threshold (should be a scalar since A is 1×20)
    Aeq = ones(1, 20); % Weights sum to 1
    beq = 1;
    
    % Set optimization options
    options = optimoptions('quadprog', 'TolFun', 1e-9);
    
    % Solve for optimal portfolio weights
    x = quadprog(2 * Q, [], A, b, Aeq, beq, lb, [], [], options);
    

    
end
