% bkgrnd_prec = dlmread('bkgrnd_prec.csv', ',');
% foregrnd_prec = dlmread('foregrnd_prec.csv', ',');
% bkgrnd_data = dlmread('bkgrnd_data.csv', ',');
% foregrnd_data = dlmread('foregrnd_data.csv', ',');
% delta_prec = dlmread('delta_prec.csv', ',');

epsilon = 0.01;

S = cov(bkgrnd_data);
[X, X_history] = covsel(S, 5.5, 1, 1);
X = corrcov(X+epsilon*eye(size(X,1)));

for lambda=1:0.1:1
    S = cov(foregrnd_data);
    [Y, Y_history] = covsel_nz_bkgrnd(S, X, lambda, 1, 1);
    Y = corrcov(Y+epsilon*eye(size(Y,1)), 1);

    S = cov(foregrnd_data);
    [Z, Z_history] = covsel(S, lambda, 1, 1);
    Z = corrcov(Z+epsilon*eye(size(Z,1)), 1);
    Z(logical(eye(size(Z)))) = 0;
    
    [I,J] = find(X~=0);
    detected_bkgrnd_prec = reshape([I,J]',1,[]);
    [I,J] = find(Y~=0 & X==0);
    detected_delta_prec_csad = reshape([I,J]',1,[]);
    [I,J] = find(Z~=0);
    detected_delta_prec_bsad = reshape([I,J]',1,[]);
    
    dlmwrite('detected_bkgrnd_prec.csv', detected_bkgrnd_prec, ',');
    dlmwrite('detected_delta_prec_csad.csv', detected_delta_prec_csad, ',');
    dlmwrite('detected_delta_prec_bsad.csv', detected_delta_prec_bsad, ',');

    [I,J] = find(bkgrnd_prec==0 & Y~=0 & delta_prec~=0);
    detected_delta_csad_correct = reshape([I,J]',1,[]);
    [I,J] = find(bkgrnd_prec==0 & Y~=0 & delta_prec==0);
    detected_delta_csad_incorrect = reshape([I,J]',1,[]);
    
    dlmwrite('detected_delta_csad_correct.csv', detected_delta_csad_correct, ',');
    dlmwrite('detected_delta_csad_incorrect.csv', detected_delta_csad_incorrect, ',');

    [I,J] = find(Z~=0 & delta_prec~=0);
    detected_delta_bsad_correct = reshape([I,J]',1,[]);
    [I,J] = find(Z~=0 & delta_prec==0);
    detected_delta_bsad_incorrect = reshape([I,J]',1,[]);
    
    dlmwrite('detected_delta_bsad_correct.csv', detected_delta_bsad_correct, ',');
    dlmwrite('detected_delta_bsad_incorrect.csv', detected_delta_bsad_incorrect, ',');
    
    bkgrnd_tp = bkgrnd_prec & X;
    tp = ~bkgrnd_prec & delta_prec & Y;
    baseline_tp = delta_prec & Z;

    bkgrnd_fp = ~bkgrnd_prec & X;
    fp = ~bkgrnd_prec & ~delta_prec & Y;
    baseline_fp = ~delta_prec & Z;

    bkgrnd_tn = ~bkgrnd_prec & ~X;
    tn = ~bkgrnd_prec & ~delta_prec & ~Y;
    baseline_tn = ~delta_prec & ~Z;

    bkgrnd_fn = bkgrnd_prec & ~X;
    fn = ~bkgrnd_prec & delta_prec & ~Y;
    baseline_fn = delta_prec & ~Z;

    bkgrnd_tp = sum(sum(bkgrnd_tp));
    bkgrnd_fp = sum(sum(bkgrnd_fp));
    bkgrnd_tn = sum(sum(bkgrnd_tn));
    bkgrnd_fn = sum(sum(bkgrnd_fn));

    tp = sum(sum(tp));
    fp = sum(sum(fp));
    tn = sum(sum(tn));
    fn = sum(sum(fn));

    baseline_tp = sum(sum(baseline_tp));
    baseline_fp = sum(sum(baseline_fp));
    baseline_tn = sum(sum(baseline_tn));
    baseline_fn = sum(sum(baseline_fn));

    fprintf('Lambda %f Precision %f Recall %f BaselinePrecision %f BaselineRecall %f\n', lambda, 1.0*tp/(tp+fp), 1.0*tp/(tp+fn), 1.0*baseline_tp/(baseline_tp+baseline_fp), 1.0*baseline_tp/(baseline_tp+baseline_fn));
end

K = length(Y_history.objval);
X_admm = X;

% h = figure;
% plot(1:K, Y_history.objval, 'k', 'MarkerSize', 10, 'LineWidth', 2);
% ylabel('f(x^k) + g(z^k)'); xlabel('iter (k)');

g = figure;
subplot(2,1,1);
semilogy(1:K, max(1e-8, Y_history.r_norm), 'g', ...
    1:K, Y_history.eps_pri, 'r:',  'LineWidth', 2);
ylabel('||\Theta-Z||_F','FontSize',16);

subplot(2,1,2);
semilogy(1:K, max(1e-8, Y_history.s_norm), 'g', ...
    1:K, Y_history.eps_dual, 'r:', 'LineWidth', 2);
ylabel('||\rho(Z-Z_{old})||_F','FontSize',16);
xlabel('Iteration','FontSize',16);
