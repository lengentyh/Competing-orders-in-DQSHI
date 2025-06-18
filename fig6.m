clear all

% Generate mesh
N = 1000; % mesh resolution
D_d_temp         = linspace(0,1,N);
v_epsilon_temp   = 120;
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
a0 = 4e-9;% in m
J0 = 1e-4;
eta_SC  = (1./K0).*(2*acos(K1)./(pi*sqrt(1-K1.^2)));
eta_SDW = K0.*(1 + (2/pi)*K1);

L  = zeros(size(D_d));
L(isSDW)        = a0*(J0.^(-1./(2-eta_SDW(isSDW))));
L(isSC)         = a0*(J0.^(-1./(2-eta_SC(isSC))));
L(isSC & isSDW) = min(a0*(J0.^(-1./(2-eta_SDW(isSC & isSDW)))), a0*(J0.^(-1./(2-eta_SC(isSC & isSDW)))));
% convert to Kelvin (i.e., \times kB/ \hbar v)
hbar_v = 1e-11; % eV * m
kB     = 8.617e-5; % eV/K
T = hbar_v./(kB*L);

% 1. Reshape for grid-based plotting and boundary detection
T_grid          = reshape(T,        [N, 1]);
region_grid     = reshape(region_type, [N, 1]);
D_d_grid        = reshape(D_d,      [N, 1]);
v_epsilon_grid  = reshape(v_epsilon,[N, 1]);

T_grid = 1000*T_grid; % convert to mK

% 2. Plot colormap of T
figure;
hold on
SC_color   = [0.34, 0.23, 0.51];
SDW_color  = [0.53, 0.85, 0.52];
both_color = [0.59, 0.39, 0.22];
colors = {SDW_color, SC_color, both_color}; % SDW, SC, competing

% Identify contiguous regions and patch them
region_edges = [1; find(diff(region_grid) ~= 0) + 1; N + 1];
for i = 1:length(region_edges)-1
    start_idx = region_edges(i);
    if i == length(region_edges)-1
        end_idx = region_edges(i+1) - 1;
    else
        end_idx = region_edges(i+1);
    end
    region = region_grid(start_idx);
    fill([D_d_grid(start_idx) D_d_grid(end_idx) D_d_grid(end_idx) D_d_grid(start_idx)], ...
         [0 0 max(T_grid)*1.1 max(T_grid)*1.1], colors{region}, 'EdgeColor', 'none');
end

h1 = plot(D_d_grid, T_grid, 'LineWidth', 4, 'Color', 'b');

text(0.075, 0.12*1000, {'\pi-';'SDW'}, 'Color', [0.8500 0.3250 0.0980], 'FontSize', 40, 'HorizontalAlignment', 'center');
text(0.6, 0.12*1000, '\pi-SC', 'Color', [0.8 0.8 0.8], 'FontSize', 50, 'HorizontalAlignment', 'center');
text(0.28, 0.12*1000, '\pi-SC/\pi-SDW', 'Color', [0.8 0.8 0.1], 'FontSize', 40, 'HorizontalAlignment', 'center');

% 3. Axis settings
box on
ax = gca;
set(gca,'FontSize',24)
ax.LineWidth = 2;
fontsize = 48;
xlabel('$\bf{D/d}$','FontSize',fontsize,'Interpreter','latex')
ylabel('$\bf{T^* (mK)}$','FontSize',fontsize,'Interpreter','latex')
yticks([0:0.025:0.125]*1000)
axis([0 1 0 max(T_grid)*1.1])
set(gca,'FontSize',fontsize)