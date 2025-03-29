function x = RiskParity(mu, Q)

%formulate retractable (convex) risk parity optimization
% min 1/2y'Qy - c(sum(ln(y_i))), y>=0

%number of assets
N = size(Q, 1);

%initial equal weighted portfolio
y0 = 1/N.*(ones(N,1)); 

%parameter c > 0, does not need fine tuning
c = 70;
%lambda = 5;

%set equality constraints (none)
Aeq = [];
beq = [];

%set inequality constraints (none)
A = [];
b = [];

%no restrictions on bounds, allow short selling
%lb = [];
%ub = [];

%run optimizer with objective function
%allow short selling. no restriction on ub/lb

options = optimoptions('fmincon', 'Display', 'off');
y = fmincon(@(y) RPobj(y, Q, c), y0, A, b, Aeq, beq, [], [], [], options);


%recover optimal asset weights

x = y ./ sum(y);
disp(x);
end


function f = RPobj(x, Q, c)

    f = (1/2) * (x'*Q*x);
    n = size(Q, 1);

    %create ln's

    for i = 1:n
        %f = f - c*log(x(i)) - lambda*(x'*Q*x);
        f = f - c*log(x(i));

    end

end