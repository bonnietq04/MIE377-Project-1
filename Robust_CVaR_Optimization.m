function x = Robust_CVaR_Optimization(rets, facRets, alpha)
    [S, n] = size(rets);

    % Define the confidence level
    if nargin < 3
        alpha = 0.95;
    end

    % Estimate expected returns using geometric mean
    mu = (geomean(rets + 1) - 1 )';

    % Estimate a robust margin: standard error scaled by robustness factor
    robustness_factor = 0.5;  % adjust this to tune conservativeness
    mu_std = std(rets)' / sqrt(S);
    delta = robustness_factor * mu_std;

    % Define robust lower bound for mu
    mu_robust = mu - delta;

    % Set target return: geometric mean of first factor
    R = geomean(facRets(:,1) + 1) - 1;

    % Lower and upper bounds
    lb = [zeros(n, 1); zeros(S,1); -Inf];
    ub = [];

    % Build inequality constraint matrix A and vector b
    A = zeros(S+1, n + 1 + S);
    b = [zeros(S, 1); -R];

    for s = 1:S
        A(s, 1:n) = -rets(s,:);
        A(s, n+s) = -1;
        A(s, n+1+S) = -1;
    end

    % Robustified return constraint: (mu - delta)' * x >= R
    A(S+1, 1:n) = -mu_robust';
    A(S+1, n+1:n+S+1) = 0;

    % Equality constraint: sum(x) = 1
    Aeq = [ones(1, n), zeros(1, S+1)];
    beq = 1;

    % Objective vector
    c = zeros(n + 1 + S, 1);
    c(n+1:n+S) = 1 / ((1 - alpha) * S);
    c(n+1+S) = 1;

    % Optimization options
    options = optimoptions('linprog', 'TolFun', 1e-9);

    % Solve LP
    y = linprog(c, A, b, Aeq, beq, lb, ub, options);

    % Return optimal weights
    x = y(1:n);
end
