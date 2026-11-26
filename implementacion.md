---
layout: default
title: "4. Implementación"
nav_order: 5
---

# 4. Implementación

Se construyó un entorno de simulación para el péndulo rotatorio del **Quanser QUBE-Servo 3, unidad Péndulo 2**, a partir de un modelo dinámico no lineal y de una representación de los encoders y observadores. El entorno permitió entrenar la política de balance, verificar su transferencia de Python a MATLAB y probar su integración en Simulink antes del ensayo en laboratorio.

## 4.1 Construcción del entorno de simulación
{: #modelo-no-lineal }

El modelo utiliza el estado $x=[\theta,\alpha,\dot{\theta},\dot{\alpha}]^T$ y la entrada $u=V_m$. El ángulo $\theta$ corresponde al brazo y $\alpha=0$ representa la vertical invertida. La dinámica incluye el acoplamiento entre brazo y péndulo, la gravedad, el amortiguamiento y la fuerza contraelectromotriz del motor. La relación empleada para el par del motor es

$$\tau=\frac{k_m}{R_m}\left(V_m-k_m\dot{\theta}\right).$$

El modelo de Python integra la planta con Runge–Kutta de cuarto orden a **2 ms**. El agente selecciona una acción cada **10 ms**, de modo que el voltaje se mantiene durante cinco pasos de integración. Como comprobación del modelo, el código compara la linealización numérica alrededor de $x=0$, $u=0$ con las matrices $A$ y $B$ del LQR de referencia. La comprobación cubre la coherencia local del modelo. La correspondencia con la planta fuera de ese punto requiere mediciones experimentales.

### Parámetros de la planta

Los valores de la consigna se conservan como referencia para el ensayo de robustez. La columna del simulador identifica los valores base del modelo usado con los pesos disponibles de balance, antes de cualquier variación por episodio.

| Parámetro | Símbolo | Cuadro 2 | Simulador de balance | Unidad |
|---|---|---:|---:|---|
| Resistencia de armadura | $R_m$ | 8.4 | 7.5 | Ω |
| Constante del motor | $k_m$ | 0.042 | 0.0422 | N·m/A para la constante de par |
| Masa del brazo | $m_r$ | 0.095 | 0.095 | kg |
| Longitud del brazo | $L_r$ | 0.085 | 0.085 | m |
| Masa del péndulo | $m_p$ | 0.024 | 0.024 | kg |
| Longitud total del péndulo | $L_p$ | 0.129 | 0.129 | m |
| Amortiguamiento del brazo | $D_r$ | 0.0015 | 0.001 | N·m·s/rad |
| Amortiguamiento del péndulo | $D_p$ | 0.0005 | 0.00005 | N·m·s/rad |
| Aceleración gravitatoria | $g$ | 9.81 | 9.81 | m/s² |

El Cuadro 2 emplea inercias de barra respecto de su centro de masa. El código de balance calcula $J_r=m_rL_r^2/3$ y $J_p=m_pL_p^2/3$ respecto del pivote y las utiliza en su propia matriz de dinámica. Al cambiar de modelo o variar masas y longitudes, las inercias se recalculan de acuerdo con la formulación correspondiente.

## 4.2 Estimación de velocidades

Los encoders proporcionan posiciones angulares. En el entorno de balance se reproduce su cuantización con **2048 cuentas por vuelta** y se usa un **observador de tercer orden** para cada ángulo. El observador corrige sus estados con la diferencia entre la posición medida y la estimada, y entrega las velocidades que recibe la red. En la simulación de MATLAB, la planta se integra con RK4 y los observadores se actualizan con Euler a 2 ms.

La prueba de balance en simulación inicializa el observador con una velocidad consistente con el estado inicial. En el laboratorio esa velocidad debe estimarse a partir de la señal del encoder. Esta diferencia es relevante al capturar el péndulo, porque el supervisor necesita distinguir un paso rápido por la vertical de una entrada a baja velocidad en la región de balance.

## 4.3 Entrenamiento y validación de la política de balance

El entrenamiento en Python produjo los pesos de la red, las escalas de entrada y la tabla de voltajes discretos. Al exportarlos al archivo `dqn_qube.mat` se conservaron el orden de los estados y el periodo de decisión. En MATLAB, `cargar_red_dqn` prepara la política para que seleccione el voltaje asociado al mayor valor de la red.

| Etapa | Archivo o modelo | Qué se comprobó |
|---|---|---|
| **A1. MATLAB** | `prueba_dqn_modelo_no_lineal.m` | Concordancia de las acciones exportadas para estados de prueba y respuesta del modelo ante una desviación inicial y una perturbación de velocidad. |
| **A2. Simulink** | `construir_entorno_pruebas.m` → `qube_dqn_pruebas.slx` | Ejecución en lazo cerrado sin QUARC, con planta simulada, encoders, observador y política discreta. |
| **Ensayo físico** | `conectar_al_simulink_original.m` → `qs3_dqn_ctrl.slx` | Conexión de la política a una copia del modelo del laboratorio, con los estados medidos y estimados del equipo. |

Las señales principales para comparar corridas son $\theta(t)$, $\alpha(t)$ y $V_m(t)$. La concordancia de acciones comprueba la exportación de la política. Las trayectorias y sus métricas comprueban el comportamiento del lazo.

## 4.4 Transferencia al QUBE-Servo 3

La copia de laboratorio conserva QUARC, los encoders, los observadores y el habilitador angular del modelo de balance. El bloque LQR se sustituyó por la política DQN. Un retenedor fija el periodo de decisión y un bloque de transición de tasa lleva la salida al paso de ejecución del modelo. El LQR original se conservó como referencia experimental.

En el ensayo físico inicial, el péndulo se colocó manualmente cerca de la vertical invertida. Con el DQN, el brazo osciló rápidamente y el equilibrio no se sostuvo. El diagnóstico requiere comparar las señales estimadas y el voltaje aplicado, y revisar los transitorios del observador, la saturación y el tiempo real de ejecución. La evidencia disponible no establece una causa única.

## 4.5 Integración de levantamiento y balance

La extensión de simulación usa dos políticas. El agente de *swing-up* lleva el péndulo desde la posición colgante hacia la región de captura. El supervisor selecciona la política de balance cuando el ángulo y la velocidad angular del péndulo cumplen las condiciones de captura y el brazo permanece dentro de su margen de movimiento. El habilitador angular del controlador de balance de laboratorio no cumple la función de ese supervisor.

Para validar la secuencia conjunta se requiere registrar el instante de captura, el modo activo, $\theta(t)$, $\alpha(t)$, las velocidades estimadas y $V_m(t)$. La transferencia física documentada corresponde al agente de balance. La validación de la secuencia completa en el QUBE-Servo 3 queda pendiente.

[Diseño de los agentes y análisis de robustez]({{ '/dqn.html' | relative_url }})
