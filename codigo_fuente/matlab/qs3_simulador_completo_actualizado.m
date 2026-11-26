%% PROYECTO FINAL - CONTROL INTELIGENTE
% QUBE-SERVO 3: modelo no lineal y LQR de referencia
% Valores nominales: Cuadro 2, Proyecto final Control Inteligente O26
% No entrena aun un DQN; no requiere planta fisica.
clc; clear; close all;

%% 1. PARAMETROS DEL SIMULADOR (FORMATO DEL SCRIPT ORIGINAL)
% Motor
Rm = 8.4;          % Resistencia de armadura [ohm] (PDF)
kt = 0.042;        % Constante de torque [N*m/A] (PDF: km)
km = 0.042;        % Constante de fuerza contraelectromotriz [V*s/rad]

% Rotary Arm / Brazo rotatorio
mr = 0.095;        % Masa del brazo [kg] (PDF)
r  = 0.085;        % Longitud del brazo Lr [m] (PDF)
Jr = mr*r^2/12;    % Inercia usada en ecuacion (4) del PDF [kg*m^2]
br = 1.5e-3;       % Amortiguamiento del brazo Dr [N*m*s/rad] (PDF)

% Pendulum Link / Pendulo
mp = 0.024;        % Masa del pendulo [kg] (PDF)
Lp = 0.129;        % Longitud del pendulo [m] (PDF)
l  = Lp/2;         % Posicion del centro de masa [m]
Jp = mp*Lp^2/12;   % Inercia usada en ecuacion (4) del PDF [kg*m^2]
bp = 5e-4;         % Amortiguamiento del pendulo Dp [N*m*s/rad] (PDF)
g  = 9.81;         % Gravedad [m/s^2] (PDF)

%% 2. PARAMETROS DE SIMULACION (PROPUESTAS, NO DEL CUADRO 2)
Ts_sim   = 0.002;          % Paso maximo interno de ode45 [s]
Ts_agent = 0.010;          % Periodo propuesto para el futuro DQN [s]
Vmax_sim = 3.0;            % Saturacion conservadora de simulacion [V]
alpha_lim = deg2rad(15);  % Limite angular propuesto, pendulo [rad]
theta_lim = deg2rad(60);  % Limite angular propuesto, brazo [rad]
Tmax = 5.0;                % Horizonte maximo [s]
acciones_DQN = linspace(-Vmax_sim,Vmax_sim,7);

% Reunir parametros para pasarlos a las funciones locales.
% Los valores fisicos se definen arriba, en el cuerpo principal.
p = struct();
p.Rm = Rm; p.kt = kt; p.km = km;
p.mr = mr; p.r = r; p.Jr = Jr; p.br = br;
p.mp = mp; p.Lp = Lp; p.l = l; p.Jp = Jp; p.bp = bp;
p.g = g; p.Vmax_sim = Vmax_sim;
p.alpha_lim = alpha_lim; p.theta_lim = theta_lim;

fprintf('\n=== PARAMETROS NOMINALES DEL PDF ===\n');
fprintf('Rm=%.4f ohm, kt=%.4f, km=%.4f\n',Rm,kt,km);
fprintf('Jr=%.9g, Jp=%.9g kg*m^2\n',Jr,Jp);
fprintf('br=%.6g, bp=%.6g N*m*s/rad\n',br,bp);
fprintf('Acciones propuestas del DQN [V]: ');
fprintf('%g ',acciones_DQN); fprintf('\n');

%% 3. COMPROBAR EQUILIBRIO Y LINEALIZAR EL MODELO NO LINEAL
% Estado x = [theta; alpha; dtheta; dalpha], con alpha=0 arriba.
xeq = zeros(4,1);
ueq = 0;
dx_eq = qs3_dinamica_local(xeq,ueq,p);
fprintf('\nDerivadas en equilibrio: ');
fprintf('%.3g ',dx_eq); fprintf('\n');

h = 1e-6;
A = zeros(4,4);
for i = 1:4
    e = zeros(4,1);
    e(i) = h;
    A(:,i) = (qs3_dinamica_local(xeq+e,ueq,p) ...
             - qs3_dinamica_local(xeq-e,ueq,p))/(2*h);
end
B = (qs3_dinamica_local(xeq,ueq+h,p) ...
    -qs3_dinamica_local(xeq,ueq-h,p))/(2*h);

fprintf('\nMatriz A linealizada:\n'); disp(A);
fprintf('Matriz B linealizada:\n'); disp(B);
fprintf('Autovalores en lazo abierto:\n'); disp(eig(A));
Co = [B A*B A^2*B A^3*B];
fprintf('Rango de controlabilidad: %d/4\n',rank(Co));

%% 4. LQR DE REFERENCIA (NO ES EL AGENTE DQN)
% Pesos tomados de tu script de Control Avanzado.
Q = diag([1 20 0.1 0.1]);
R = 10;
K = lqr(A,B,Q,R);  % Requiere Control System Toolbox
fprintf('\nGanancia LQR sobre el modelo no lineal linealizado:\n');
disp(K);
fprintf('Polos en lazo cerrado:\n'); disp(eig(A-B*K));

%% 5. SIMULACIONES EN LA PLANTA NO LINEAL
% Condicion inicial: brazo 0 grados, pendulo 2 grados.
x0 = [0; deg2rad(2); 0; 0];
opciones = odeset('RelTol',1e-8,'AbsTol',1e-10, ...
    'MaxStep',Ts_sim, ...
    'Events',@(t,x) qs3_evento_local(t,x,p));

% Caso A: planta libre, sin voltaje.
[t_libre,X_libre,te_libre] = ode45( ...
    @(t,x) qs3_dinamica_local(x,0,p),[0 Tmax],x0,opciones);

% Caso B: planta no lineal con voltaje LQR saturado.
[t_lqr,X_lqr,te_lqr] = ode45( ...
    @(t,x) qs3_dinamica_local(x,qs3_voltaje_lqr(x,K,p),p), ...
    [0 Tmax],x0,opciones);

V_lqr = zeros(length(t_lqr),1);
for i = 1:length(t_lqr)
    V_lqr(i) = qs3_voltaje_lqr(X_lqr(i,:)',K,p);
end

fprintf('\n=== RESUMEN DE SIMULACION ===\n');
fprintf('Sin control: termino a t=%.3f s',t_libre(end));
if ~isempty(te_libre), fprintf(' (limite angular)'); end
fprintf('\n');
fprintf('Con LQR:    termino a t=%.3f s',t_lqr(end));
if ~isempty(te_lqr), fprintf(' (limite angular)'); end
fprintf('\n');
fprintf('Alpha final libre = %.3f grados\n',rad2deg(X_libre(end,2)));
fprintf('Alpha final LQR   = %.3f grados\n',rad2deg(X_lqr(end,2)));
fprintf('Voltaje pico LQR  = %.3f V\n',max(abs(V_lqr)));

%% 6. GRAFICAS
figure('Name','QUBE-Servo 3: sin control vs. LQR','NumberTitle','off');
etiquetas = {'Theta [grados]','Alpha [grados]', ...
    'dTheta [grados/s]','dAlpha [grados/s]'};
titulos = {'Posicion del brazo','Posicion del pendulo', ...
    'Velocidad del brazo','Velocidad del pendulo'};
for i = 1:4
    subplot(3,2,i);
    plot(t_libre,rad2deg(X_libre(:,i)),'r--','LineWidth',1.3);
    hold on;
    plot(t_lqr,rad2deg(X_lqr(:,i)),'b','LineWidth',1.3);
    grid on;
    xlabel('Tiempo [s]'); ylabel(etiquetas{i}); title(titulos{i});
    legend('Libre','LQR','Location','best');
end
subplot(3,2,5);
plot(t_lqr,V_lqr,'b','LineWidth',1.3);
grid on; xlabel('Tiempo [s]'); ylabel('Vm [V]'); title('Voltaje LQR');
subplot(3,2,6);
plot(rad2deg(X_libre(:,2)),rad2deg(X_libre(:,4)), ...
    'r--','LineWidth',1.3); hold on;
plot(rad2deg(X_lqr(:,2)),rad2deg(X_lqr(:,4)), ...
    'b','LineWidth',1.3);
grid on; xlabel('Alpha [grados]'); ylabel('dAlpha [grados/s]');
title('Plano de fase'); legend('Libre','LQR','Location','best');
sgtitle('Simulador nominal no lineal - pendiente de validacion experimental');

%% FUNCIONES LOCALES (NO CAMBIAR LOS PARAMETROS AQUI)
function dx = qs3_dinamica_local(x,Vm,p)
    alpha = x(2); dtheta = x(3); dalpha = x(4);
    sa = sin(alpha); ca = cos(alpha);
    Vm = max(-p.Vmax_sim,min(p.Vmax_sim,Vm));

    % Matriz de inercia de la ecuacion (4) del PDF
    M11 = p.Jr + p.mp*p.r^2 + (p.mp*p.Lp^2/4)*sa^2;
    M12 = -(p.mp*p.Lp*p.r/2)*ca;
    M22 = p.Jp + p.mp*p.Lp^2/4;
    M = [M11 M12; M12 M22];

    % Torque fisicamente consistente: i=(Vm-km*dtheta)/Rm; tau=kt*i.
    % La expresion del PDF presenta una notacion ambigua en este termino.
    tau = (p.kt/p.Rm)*(Vm-p.km*dtheta);

    F1 = tau - p.br*dtheta ...
       - (p.mp*p.Lp^2/2)*sa*ca*dtheta*dalpha ...
       - (p.mp*p.Lp*p.r/2)*sa*dalpha^2;
    F2 = -p.bp*dalpha ...
       + (p.mp*p.Lp^2/4)*sa*ca*dtheta^2 ...
       + (p.mp*p.Lp*p.g/2)*sa;
    ddq = M\[F1;F2];
    dx = [dtheta; dalpha; ddq(1); ddq(2)];
end

function Vm = qs3_voltaje_lqr(x,K,p)
    Vm = -K*x;
    Vm = max(-p.Vmax_sim,min(p.Vmax_sim,Vm));
end

function [value,isterminal,direction] = qs3_evento_local(~,x,p)
    value = [p.alpha_lim-abs(x(2));p.theta_lim-abs(x(1))];
    isterminal = [1;1];
    direction = [-1;-1];
end
