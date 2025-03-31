function x = CVaR_Optimization(rets, facRets, alpha)
    [S, n] = size(rets);
    
    % Define the confidence level
    alpha = 0.95;
    
    % Estimate the asset exp. returns by taking the geometric mean
    mu = (geomean(rets + 1) - 1 )';
    
    % Set our target return by taking the geometric mean of the factor returns
    %R = mean(geomean(facRets + 1) - 1);
    

    %%Only onefactor:
    R = geomean(facRets(:,1) + 1) - 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 2. Construct the appropriate matrices for optimization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % We can model CVaR Optimization as a Linear Program.
    %
    %   min     gamma + (1 / [(1 - alpha) * S]) * sum( z_s )
    %   s.t.    z_s   >= 0,                 for s = 1, ..., S
    %           z_s   >= -r_s' x - gamma,   for s = 1, ..., S
    %           1' x  =  1,
    %           mu' x >= R
    %
    % Therefore, we will use MATLAB's 'linprog' in this example. In this
    % section of the code we will construct our inequality constraint matrix
    % 'A' and 'b' for
    %
    %   A x <= b
    %
    % This means we need to rearrange our constraint to have all the variables
    % on the LHS of the inequality.
    
    % Define the lower and upper bounds to our portfolio
    lb = [-45 * ones(n, 1); zeros(S,1); -Inf];  % allow shorting up to -100%
    ub = [ 45 * ones(n, 1);  Inf(S,1);  Inf];%} % allow long positions up to 200%
    %lb = [-Inf(n, 1); zeros(S,1); -Inf];
    %ub = [];


    
    % Define the inequality constraint matrices A and b
    A = zeros(S+1, n + 1 + S);
    b = [zeros(S, 1); -R];
    
    for s = 1:S
        A(s, 1:n) = -rets(s,:);      
        A(s, n+s) = -1;               
        A(s, n+1+S) = -1;             
    end
    A(S+1, 1:n) = -mu';
    A(S+1, n+1:n+S+1) = 0;
    
    % Define the equality constraint matrices A_eq and b_eq
    Aeq = [ones(1, n), zeros(1, S+1)];
    beq = 1;
         
    
    % Define our objective linear cost function c
    c = zeros(n + 1 + S, 1);
    c(n+1+S) = 1;                          
    c(n+1:n+S) = 1 / ((1 - alpha) * S); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 3. Find the optimal portfolio
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Set the linprog options to increase the solver tolerance
    
    options = optimoptions('linprog','TolFun',1e-9);
    
    % Use 'linprog' to find the optimal portfolio
    

    y = linprog( c, A, b, Aeq, beq, lb, ub, options );
    
    % Retrieve the optimal portfolio weights
    x = y(1:n);
end
