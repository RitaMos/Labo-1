clear all; close all;

f = 4e3;
C1 = 20e-9;
R4 = 5.04e3;

w = 2 * pi * f;
D_min = 0.1;
D_max = 0.4;
N = 10;             % pasos para graficar
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

Cx_vector = linspace(Cx_min, Cx_max, N);
Rx_vector = linspace(Rx_min, Rx_max, N);

S_R1 = zeros(N, N);
S_R3 = zeros(N, N);

for idx_Rx = 1:N
  for idx_Cx = 1:N
      Rx = Rx_vector(idx_Rx);
      Cx = Cx_vector(idx_Cx);

      R3 = Cx * R4 / C1;
      R1 = Rx * R3 / R4;
      
      % --- MODIFICACIÓN 2: Impedancias en SERIE (z = R + 1/(i*w*C)) ---
      z2 = Rx + 1/(i*w*Cx);
      z1 = R1 + 1/(i*w*C1);

      deltaz1 = (R1 + deltaR1) + 1/(i*w*C1);
        
      % Las ecuaciones del puente se mantienen igual porque la topología es la misma
      S_R1(idx_Cx, idx_Rx) = Vin * abs((z2 * R3 - deltaz1 * R4)/((deltaz1 + R3)*(R4 + z2)));
      S_R3(idx_Cx, idx_Rx) = Vin * abs((z2 * (R3 + deltaR3) - z1 * R4)/((z1 + R3 + deltaR3)*(R4 + z2)));
  end
end

surf(Rx_vector./1000, Cx_vector.*1e9, S_R1);
hold on;
surf(Rx_vector./1000, Cx_vector.*1e9, S_R3);

xlabel('R_x (k\Omega)');
ylabel('C_x (nF)');
zlabel('Voltaje de Sensibilidad (V)');
grid on;
view(135, 30);
colormap jet;
colorbar;