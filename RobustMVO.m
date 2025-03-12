function x = RobustMVO(mu, Q,periodReturns,periodFactRet, x0)

    % Use this function to implement your algorithmic asset management
    % strategy. You can modify this function, but you must keep the inputs
    % and outputs consistent.
    %
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)
    %
    % An example of an MVO implementation with OLS regression is given
    % below. Please be sure to include comments in your code.
    %
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------
    mu(isnan(mu)) = 0; % Replace NaNs in expected returns
    Q(isnan(Q)) = 0; % Replace NaNs in covariance matrix

    
    % Example: Use MVO to optimize our portfolio
    n = size(periodReturns,2);

    % Number of observations;
    N = size(periodReturns, 1);

    % Calculate the factor expected excess return from historical data using
    % the geometric mean
    %mu = mean(periodReturns);
    %mu = mu(:);

    % Calculate the asset covariance matrix
    %Q = cov(periodReturns);

    % Calculate the factor expected excess return from historical data using
    % the geometric mean. Use this as the portfolio target return
    %logReturns = log(1 + periodFactRet);

    % Compute the mean of log returns
    %meanLogRet = mean(logReturns);

    % Convert back to geometric mean return
    %targetRet = exp(meanLogRet) - 1;
    x0 = ones(n, 1) / n;

    %parameter calcs
    theta = ((1/N)*diag(Q).*eye(n)).^0.5; %calculation of theta
    alpha = 0.9; %confidence level, so this is with 90% confidence
    epsilon = sqrt(chi2inv(alpha,n)); %calculation of epsilon (size of uncertainty set). uses chi^2 distribution 

    lambda = 20; %risk aversion penalty, dont need


    %use fmincon
    fun = @(x) lambda*(x'*Q*x)-mu' * x;
    
    function [c, ceq] = robustConstraint(x)
    % c(x) <= 0 defines inequality constraints
        c = - (mu' * x - epsilon * norm(theta .* x, 2));
        ceq = []; 
    end

    x0 = 1/n.*(ones(n,1));
    A = [];
    b = [];
    Aeq = ones(1,n);
    beq = 1;

    nonlcon = @(x) robustConstraint(x, mu, theta, epsilon, targetRet);
    %lb = zeros(n,1); if you have this or don't, asset weights are still
    %positive
    ub = [];
    options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
    x = fmincon(fun,x0,A,b,Aeq,beq,[], ub, @robustConstraint,options);
    x


   end
    
