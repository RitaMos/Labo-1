%% 
clear all; close all;

f = 4e3;
C1 = 20e-9;
R4 = 5.04e3;

w = 2 * pi * f;
D_min = 0.1;
D_max = 0.4;
N = 100
0;             % pasos para graficar
Vin = 5;

Cx_min = 2e-9;
Cx_max = 20e-9;

% --- MODIFICACIÓN 1: Cálculo de Rx para configuración SERIE (Rx = Dx / (w*Cx)) ---
Rx_min = D_min / (w * Cx_max);
Rx_max = D_max / (w * Cx_min);

R3_min = Cx_min*R4/C1;
R3_max = Cx_max*R4/C1;
R1_min = Rx_min*R3_min/R4;
R1_max = Rx_max*R3_max/R4;
deltaR3 = R3_max/(20*4);  % sensibilidad para un cuarto de vuelta
deltaR1 = R1_max/(20*4);  % 20 vueltas para recorrer el rango

R1_vector = linspace(R1_min, R1_max, N);
R3_vector = linspace(R3_min, R3_max, N);

Vd = zeros(N, N);

for idx_R1 = 1:N
    for idx_R3 = 1:N
        R1 = R1_vector(idx_R1);
        R3 = R3_vector(idx_R3);

        % PARA CONVERGENCIA SE VARÍA ESTE PAR
        Cx = 18e-9;
        Rx = 7500;%0.25/(w*Cx);   %D=0,25
        %-----------
        z2 = Rx + 1/(i*w*Cx);
        z1 = R1 + 1/(i*w*C1);

        % Las ecuaciones del puente se mantienen igual porque la topología es la misma
        Vd(idx_R1, idx_R3) = Vin * abs((z2 * R3 - z1 * R4)/((z1 + R3)*(R4 + z2)));
    end
end




surf(R3_vector./1000, R1_vector./1000, Vd);
hold on;

xlabel('R_3 (k\Omega)x');
ylabel('R_1 (k\Omega)y');
zlabel('Voltaje de Salida (V)');
grid on;
view(135, 30);
colormap jet;
colorbar;