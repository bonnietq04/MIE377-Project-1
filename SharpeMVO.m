function x = SharpeMVO(mu, Q,r_f)

    % Ensure mu is column vector
    %mu = mu(:);
    mu(isnan(mu)) = 0; % Replace NaNs in expected returns with 0
    Q(isnan(Q)) = 0; % Replace NaNs in covariance matrix with 0

    n  = length(mu);

    % Decision vector z = [y; kappa], dimension = n+1
    % The objective function depends only on y = z(1:n).
    objFun = @(z) z(1:n).' * Q * z(1:n);  % minimize y' Q y

    % ---------- Equality Constraints ----------
    % 1) (mu - r_f)' * y = 1
    % 2) 1' y - kappa = 0
    Aeq = [
        (mu - r_f).',  0;  % => (mu - r_f)' * y = 1
        ones(1,n),    -1   % => sum(y) - kappa = 0
    ];
    beq = [1; 0];

    % ---------- Inequality Constraints ----------
    % A y <= b * kappa  =>  A y - b kappa <= 0
    A = eye(n);               % n x n identity (selects each y_i)
    b = ones(n, 1);       % n x 1 vector, with each entry = 0.10
    
    % Transform the constraint to standard form: A*y - b*kappa <= 0.
    Aineq = [A, -b];          % This is an n x (n+1) matrix.
    bineq = zeros(n, 1);
    % ---------- Bounds ----------
    % y >= 0, kappa >= 0
    lb = [zeros(n,1); 0];
    ub = [];

    % ---------- Initial Guess ----------
    % e.g. uniform y, kappa = 1
    z0 = [ones(n,1)/n; 1];

    % ---------- fmincon Solve ----------
    options = optimoptions('fmincon','Algorithm','sqp','Display','iter');
    z_opt = fmincon(objFun, z0, Aineq, bineq, Aeq, beq, lb, ub, [], options);

    % ---------- Extract y, kappa, and Final x ----------
    y_opt = z_opt(1:n);
    kappa = z_opt(n+1);

    if abs(kappa) < 1e-12
        warning('kappa is near zero, check feasibility and constraints.');
        kappa = 1e-12;
    end

    x = y_opt / kappa;   % final portfolio weights
end