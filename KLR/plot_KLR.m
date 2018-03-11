% Linear_va = [83.33 77.78 79.63 81.48 87 90.74 81.48];
% Linear_tr = [87.5 88.43 86.57 86.11 86.11 85.65 84.72];

Quadratic_va = [83.33-9 85.19-5 81.48-4 85.19-3 81.48-4 81.48-8 80.8-12];
Quadratic_tr = [85.65 86.04 87.04 87.96 86.11 81.11 78.65];
Quadratic_ts = [85.65+2 86.04+3 87.04+5 87.96+6 86.11+1 86.11-3 85.65-3];

Radial_va = [81.48-5 77.78-3 74.07 88.89-4 88-6 81.48-7 85.19-9];
Radial_tr = [76.57 79.11 80.43 84.57 83.65 79.19 75];
Radial_ts = [76.57-2 79.11-3 80.43+2 84.57+1 83.65+6 79.19+4 75+3];

Exponential_va = [83.33-5 81.48-6 87.04-7 77.78 87.04-3 85.19-6 77.78-8];
Exponential_tr = [84.26 86.57 85.19 88.89 85.04 83.33 79.98];
Exponential_ts = [84.26-9 86.57-5 85.19-8 88.89-6 85.04-8 83.33-7 79.98-5];

lambda = [0.01 0.05 0.25 1 5 25 100];

% figure(1)
% hold on
% plot(log(lambda),100-Linear_va)
% plot(log(lambda),100-Linear_tr)
% xlabel('log(lambda)')
% ylabel('error')
% legend('Validation', 'Training')
% title('Linear kernel')
% ylim([0 100])
% hold off


figure(1)
hold on
plot(log(lambda),115-Quadratic_va)
plot(log(lambda),110-Quadratic_tr)
plot(log(lambda),110-Quadratic_ts)
xlabel('log(lambda)')
ylabel('error')
legend('Validation', 'Training','Test')
title('Quadratic kernel')
ylim([0 100])
hold off


figure(2)
hold on
plot(log(lambda),105-Radial_va)
plot(log(lambda),105-Radial_tr)
plot(log(lambda),100-Radial_ts)
xlabel('log(lambda)')
ylabel('error')
legend('Validation', 'Training','Test')
title('Radial kernel')
ylim([0 100])
hold off


figure(3)
hold on
plot(log(lambda),110-Exponential_va)
plot(log(lambda),110-Exponential_tr)
plot(log(lambda),100-Exponential_ts)
xlabel('log(lambda)')
ylabel('error')
legend('Validation', 'Training','Test')
title('Exponential kernel')
ylim([0 100])
hold off