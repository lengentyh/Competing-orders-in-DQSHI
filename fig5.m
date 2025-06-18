clear all

% Generate mesh
D_d_temp         = linspace(0,1,1000);
v_epsilon_temp   = linspace(0,200,1000);
[D_mesh, E_mesh] = meshgrid(D_d_temp, v_epsilon_temp);
D_d       = D_mesh(:);
v_epsilon = E_mesh(:);
clearvars D_d_temp D_mesh E_mesh v_epsilon_temp

% Define conditions
K0 = sqrt(1./(1 + v_epsilon.*D_d)); 
K1 = v_epsilon.*D_d.^2;

isSDW = K0 < 2./(1+2*K1/pi);
isSC  = K0 > acos(K1)./(pi*sqrt(1-K1.^2));

% Define region types
region_type = zeros(size(D_d));  % 0: neither, 1: SDW, 2: SC, 3: SC & SDW
region_type(isSDW) = 1;
region_type(isSC)  = 2;
region_type(isSC & isSDW) = 3;

% Define RG terminal length
a0 = 4e-3;% in $\mu$m
J0 = 1e-4;
eta_SC  = (1./K0).*(2*acos(K1)./(pi*sqrt(1-K1.^2)));
eta_SDW = K0.*(1 + (2/pi)*K1);

L  = zeros(size(D_d));
L(isSDW)        = a0*(J0.^(-1./(2-eta_SDW(isSDW))));
L(isSC)         = a0*(J0.^(-1./(2-eta_SC(isSC))));
L(isSC & isSDW) = min(a0*(J0.^(-1./(2-eta_SDW(isSC & isSDW)))), a0*(J0.^(-1./(2-eta_SC(isSC & isSDW)))));

%figure;
%scatter(D_d, v_epsilon, 20, L, 'filled')  % 20 is marker size, L gives colormap
%colormap(jet);                            % Choose your colormap (e.g., jet, hot, parula)
%colorbar;                                 % Show colorbar for L
%caxis([min(L) max(L)]);                   % Optional: fix color axis limits
%box on

% 1. Reshape for grid-based plotting and boundary detection
N = 1000; % mesh resolution
L_grid          = reshape(L,        [N, N]);
region_grid     = reshape(region_type, [N, N]);
D_d_grid        = reshape(D_d,      [N, N]);
v_epsilon_grid  = reshape(v_epsilon,[N, N]);

% 2. Plot colormap of L
figure;
hold on
h1 = pcolor(D_d_grid, v_epsilon_grid, L_grid);
set(h1, 'EdgeColor', 'none');  % Remove grid lines for smooth colormap
colormap(turbo);
%colormap(winter);
c = colorbar('Location', 'eastoutside');
title(c, '$L^*$ ($\mu$m)', 'Interpreter', 'latex', 'FontSize', 30, 'FontWeight', 'normal');
low_lim  = round(prctile(L, 0),2);   % 1st percentile
high_lim = round(prctile(L, 90),2); % 90th percentile
caxis([low_lim high_lim]);
tick_vals = linspace(low_lim, high_lim, 10);
c.Ticks = round(tick_vals,2);
%c.TickLabels = arrayfun(@(x) sprintf('$%.2f\\times10^{%d}$', ...
%    x / 10^floor(log10(x)), floor(log10(x))), ...
%    tick_vals, 'UniformOutput', false);
c.TickLabelInterpreter = 'latex';
c.FontSize = 36;

yline(120, 'w--', 'LineWidth', 5); % TMD

% Text labels: relocated to actual region centers
text(0.07, 160, {'\pi-'; 'SDW'}, 'Color', 1.25*[0.8 0.8 0.8], 'FontSize', 48, 'HorizontalAlignment', 'center');
text(0.8, 160, '\pi-SC', 'Color', 1.25*[0.8 0.8 0.8], 'FontSize', 70, 'HorizontalAlignment', 'center');
text(0.18, 30, '\pi-SC/\pi-SDW', 'Color', 1.25*[0.8 0.8 0.8], 'FontSize', 60, 'HorizontalAlignment', 'center');

% 3. Overlay region boundaries using contours
contour(D_d_grid, v_epsilon_grid, region_grid, [0.5 1.5 2.5], 'Color', [1 0 0], 'LineStyle', '--', 'LineWidth', 2);

% 4. Axis settings
box on
ax = gca;
ax.LineWidth = 2;
fontsize = 48;
xlabel('$\bf{D/d}$','FontSize',fontsize,'Interpreter','latex')
ylabel('$\bf{2e^2/\hbar v\pi\epsilon}$','FontSize',fontsize,'Interpreter','latex')
%ax.XAxis.FontSize = fontsize;
%ax.YAxis.FontSize = fontsize;
set(gca,'FontSize',48)
axis([0 1 0 200])