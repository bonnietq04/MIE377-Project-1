function x = RiskParity(mu, Q)
% RISKPARITY Solves a convex risk parity optimization problem.
% INPUTS:
%   mu - expected returns (not used in this function)
%   Q  - covariance matrix of asset returns
% OUTPUT:
%   x  - risk parity portfolio weights

% Number of assets
N = size(Q, 1);

% Initial guess: equal weights
y0 = 1/N.*(ones(N,1)); 

% Penalty parameter for log barrier term (prevents zero weights). Optimal weights are independent of the choice of parameter c.
c = 70;

% No equality constraints
Aeq = [];
beq = [];

% No inequality constraints
A = [];
b = [];

% Set optimization options: suppress display
options = optimoptions('fmincon', 'Display', 'off');

% Minimize the objective function using fmincon
% Objective: 1/2*y'*Q*y - c*sum(log(y)), subject to y >= 0
y = fmincon(@(y) RPobj(y, Q, c), y0, A, b, Aeq, beq, [], [], [], options);


%Recover optimal asset weights
x = y ./ sum(y);
end

function f = RPobj(x, Q, c)
% RPOBJ Computes the risk parity objective function value
% INPUTS:
%   x - portfolio weights (not normalized)
%   Q - covariance matrix
%   c - penalty parameter for log barrier

% Quadratic risk term: portfolio variance
    f = (1/2) * (x'*Q*x);
   
% Add log barrier to penalize near-zero weights (ensures diversification)
    n = size(Q, 1);

%Create ln's
    for i = 1:n
        f = f - c*log(x(i));
    end
end
