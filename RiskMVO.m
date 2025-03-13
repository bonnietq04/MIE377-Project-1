%Risk-Return Tradeoff

function x = RiskMVO(mu, Q, periodReturns, x0)
    % periodReturns : (T x n) matrix of historical returns for n assets
    % periodFactRet : (T x k) matrix of factor returns (not used here, but
    %                 you might use it if you build Q or mu differently)
    % x0            : the current portfolio (if needed for warm starts)

    %x_opt = testing_optimization(periodReturns);
    % 1) Estimate the mean returns and covariance (Q) from historical data:
    % Replace NaN with 0
    %mu_ = mean(periodReturns)';  % n x 1
    %Q_  = cov(periodReturns);    % n x n

    mu(isnan(mu)) = 0; % Replace NaNs in expected returns
    Q(isnan(Q)) = 0; % Replace NaNs in covariance matrix
    % 2) Choose a risk-aversion parameter lambda (you may tune this)
    lambda = 50;  % example value

    % 3) Convert x^T Q x - lambda*mu^T x  into quadprog form:
    f = -lambda*mu;    % so that f'*x = -lambda*mu'*x
    n = size(periodReturns, 2);
    % 4) Define constraints: sum(x) = 1, x >= 0
    Aeq = ones(1, n);
    beq = 1;

    % 5) Solve via quadprog
    options = optimoptions('quadprog','Display', 'none');
    x = quadprog(2*Q,f,[],[],Aeq,beq,[],[],[],options); %no lb, but weights are all positive

    % If quadprog fails to find a feasible solution, you might want
    % to handle that case here, e.g., revert to a default portfolio.
    %if isempty(x)
        %warning('quadprog did not return a solution. Reverting to 1/n portfolio.');
        %x = ones(nAssets,1)/nAssets;
    %end

end