clear all
close all
clc

% Load Data
alt = xlsread('C_FLIGHT.CSV','O34:O15422');           % Pressure Altitude [ft]
airspeed = xlsread('C_FLIGHT.CSV','Q34:Q15422');       % TAS [knots]
long = xlsread('C_FLIGHT.CSV','T350:T15422');
lat = xlsread('C_FLIGHT.CSV','S350:S15422');
heading = xlsread('C_SYSTEM.CSV','P80:P10325');
eng_pressure = xlsread('C_ENGINE.CSV','G5:G1030');

% Filter invalid or missing data
valid_idx = ~isnan(alt) & ~isnan(airspeed);
alt = alt(valid_idx);
airspeed = airspeed(valid_idx);

% Calculate Rate of Climb (ROC) in ft/min
dt = 1; % Assuming 1 second time step
roc = [0; diff(alt)/dt] * 60; % ft/min

% Smooth ROC and airspeed for better curve fitting
roc_smooth = movmean(roc, 30);
airspeed_smooth = movmean(airspeed, 30);

% Plot Altitude
figure(1)
plot(alt)
xlabel('Count')
ylabel('Pressure Altitude [ft]')
title('Altitude vs Count')

% Plot Airspeed
figure(2)
plot(airspeed)
xlabel('Count')
ylabel('TAS [knots]')
title('True Airspeed vs Count')

% Plot Engine Pressure
figure(3)
plot(eng_pressure)
xlabel('Count')
ylabel('Engine Manifold Pressure [in.Hg]')
title('Engine Manifold Pressure')

% Plot Flight Path
figure(4)
geobubble(lat, long)
title('Flight Path')

% Plot ROC vs Airspeed
figure(5)
scatter(airspeed_smooth, roc_smooth, 10, 'filled')
xlabel('Airspeed [knots]')
ylabel('Rate of Climb [ft/min]')
title('ROC vs Airspeed')
grid on

% Fit a quadratic curve to ROC vs Airspeed
p = polyfit(airspeed_smooth, roc_smooth, 2);
v = linspace(min(airspeed_smooth), max(airspeed_smooth), 100);
roc_fit = polyval(p, v);

% Overlay fitted curve
hold on
plot(v, roc_fit, 'r', 'LineWidth', 2)

% Find max ROC and corresponding airspeed (Vy)
[max_roc, idx_max_roc] = max(roc_fit);
Vy = v(idx_max_roc);

% Find best angle of climb approximation: max(ROC / airspeed)
angle_eff = roc_fit ./ v;
[max_eff, idx_best_angle] = max(angle_eff);
Vx = v(idx_best_angle);

% Display results
fprintf('Maximum ROC: %.2f ft/min at Vy = %.2f knots\n', max_roc, Vy);
fprintf('Best angle of climb airspeed (Vx): %.2f knots (max ROC/V)\n', Vx);
