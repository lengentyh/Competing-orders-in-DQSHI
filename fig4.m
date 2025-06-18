clear all

K1     = linspace(0,1,401);
K0_SC  = (1/pi)*acos(K1).*(1./sqrt(1-K1.^2));
K0_SDW = 2./(1+(2/pi)*K1);

K0_coexist = (2/pi)*acos(K1).*(1./sqrt(1-K1.^2)).*(1./(1+(2/pi)*K1));

K0_SC(1) = 1000;
K0_SC(end) = 1000;

hold on

%plot(K0_SC,K1,'k','LineWidth',2)
%plot(K0_SDW,K1,'k','LineWidth',2)

% Define colors
blue  = [0 0 1] * 0.7; % Blue for the region between the curves
red   = [1 0 0] * 0.7; % Red for the region left to K0_SC
green = [0 1 0] * 0.7; % Green for the region left to K0_SDW

% Patch the region between K0_SC and K0_SDW
%fill([K0_SC fliplr(K0_SDW)], [K1 fliplr(K1)], blue, 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% Patch the region left to K0_SC
%fill([zeros(size(K1)) fliplr(K0_SC(2:end))], [K1 fliplr(K1(2:end))], red, 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% Patch the region left to K0_SDW
%fill([zeros(size(K1))+10 fliplr(K0_SDW)], [K1 fliplr(K1)], green, 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% SDW is relevant
fill([zeros(size(K1)) fliplr(K0_SDW)], [K1 fliplr(K1)], green, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% SC is relevant
fill([zeros(size(K1))+10 fliplr(K0_SC)], [K1 fliplr(K1)], red, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
% LL
fill([zeros(size(K1))+10 fliplr(K0_SDW)], [K1 fliplr(K1)], blue, 'EdgeColor', 'none', 'FaceAlpha', 0.5);

plot(K0_coexist,K1,'b--','LineWidth',4)

% add text to each region
text(1.75, 0.5, '(\pi-)SC', 'Color', [0.8 0.8 0.8], 'FontSize', 50, 'HorizontalAlignment', 'center');
text(0.2, 0.5, '(\pi-)SDW', 'Color', [0.8500 0.3250 0.0980], 'FontSize', 46, 'HorizontalAlignment', 'center');
text(1.05, 0.5, '(\pi-)SC/(\pi-)SDW', 'Color', [0.8 0.8 0.1], 'FontSize', 50, 'HorizontalAlignment', 'center');

hold off
box on
ax = gca;
ax.LineWidth = 2;
fontsize = 40;
xlabel('$\bf{K_0}$','FontSize',fontsize,'Interpreter','latex')
ylabel('$\bf{K_1}$','FontSize',fontsize,'Interpreter','latex')
axis([0 2 0 1])
set(gca,'FontSize',fontsize)
