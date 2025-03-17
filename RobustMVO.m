function x = RobustMVO(mu, Q, x0)

    % RobustMVO: Implements Robust Risk Trade Off Optimization with 
    % ellipsoidal uncertainty and short-selling allowed.
    %
    % INPUTS:
    %   mu  - Expected returns vector (Nx1)
    %   Q   - Covariance matrix (NxN)
    %   x0  - Initial portfolio weights (Nx1)
    %
    % OUTPUT:
    %   x   - Optimal portfolio weights (Nx1)
    %
    % Key Features:
    % - Incorporates ellipsoidal uncertainty in risk modeling.
    % - Uses robust risk trade-off optimization to balance risk and return.
    % - Allows **short-selling** (negative weights are permitted).
    % - Optimizes risk aversion penalty at 17.
    % - Uses 90% confidence level for uncertainty modeling.
    
    % ================== Preprocessing Data ==================
    %----------------------------------------------------------------------
    % Handle NaN values in expected returns and covariance matrix
    mu(isnan(mu)) = 0; % Replace NaNs in expected returns with 0
    Q(isnan(Q)) = 0; % Replace NaNs in covariance matrix with 0

    % Number of assets in the portfolio
    n = size(Q,1); % Number of assets from covariance matrix
    N = length(mu); % Number of assets from expected returns
     % ================== Uncertainty Set Construction ==================
    
    % Construct ellipsoidal uncertainty set using the covariance matrix
    theta = sqrtm(Q / N);  % Square root of scaled covariance matrix
    
    % Confidence level for uncertainty modeling
    alpha = 0.90; % 90% confidence level
    
    % Calculate uncertainty set size (epsilon) using chi-square distribution
    epsilon = sqrt(chi2inv(alpha, n)); 

    % ================== Optimization Parameters ==================
    
    % Risk Aversion Penalty (Lambda)controls the trade-off between return and risk.
    % We set it to 17 for optimal risk-return balance.
    lambda = 17;

    % ================== Objective Function ==================
    
    % Define the objective function to minimize:
    %   lambda * (x' * Q * x) - mu' * x - epsilon * norm(theta * x, 2)
    % Where:
    % - The first term: Risk term (variance of portfolio)
    % - The second term: Expected return (we want to maximize this)
    % - The third term: Uncertainty penalty (Robust Risk Adjustment)
    fun = @(x) lambda*(x'*Q*x)-mu' * x - epsilon * norm(theta * x, 2);

    % ================== Optimization ==================
    
    % We initialize an equal-weighted portfolio (1/n allocation)
    x0 = 1/n.*(ones(n,1));

    % Linear Inequality Constraints
    % A and b define constraints of the form: A*x <= b
    % No constraints defined, so we set these as empty.
    A = [];
    b = [];
    Aeq = ones(1,n);% Sum of weights must be 1
    beq = 1;% Enforces full capital allocation

    ub = [];
    options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');

    % Solve the **Robust Mean-Variance Optimization** problem
    x = fmincon(fun,x0,A,b,Aeq,beq,[], ub, [],options); % allow short selling 

   end


