sharpeVec = zeros(1, 20);
turnoverVec = zeros(1, 20);

for p = 1:20

    disp(['Running simulation for p = ', num2str(p)]);
    PCA_numComponents = p;
    save('PCA_setting.mat', 'PCA_numComponents');

    % Run the full backtest — MIE377_Project2_Main.m must end by storing:
    %   SR (Sharpe Ratio), avgTurnover (Average Turnover Rate)
    run('MIE377_Project2_Main.m');  % assumes SR and avgTurnover are printed and stored

    sharpeVec = SR;
    turnoverVec = avgTurnover;
end

% Display all results
disp('Sharpe Ratios:');
disp(sharpeVec);
disp('Turnover Rates:');
disp(turnoverVec);

% Plot results
figure;
yyaxis left
plot(1:20, sharpeVec, '-o');
ylabel('Sharpe Ratio');

yyaxis right
plot(1:20, turnoverVec, '-s');
ylabel('Average Turnover');

xlabel('Number of Principal Components');
title('Sharpe Ratio & Turnover vs. # of Principal Components');
legend('Sharpe Ratio','Turnover');
grid on;