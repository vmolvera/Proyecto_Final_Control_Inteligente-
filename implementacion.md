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

### Cálculo de las aceleraciones

El simulador resuelve un sistema acoplado de dos ecuaciones en cada evaluación de la dinámica. Con $\ell=L_p/2$, la matriz de inercia que utiliza el código es

$$
M(\alpha)=
\begin{bmatrix}
J_r+m_pL_r^2+J_p\sin^2\alpha & -m_p\ell L_r\cos\alpha\\
-m_p\ell L_r\cos\alpha & J_p
\end{bmatrix}.
$$

$$
M(\alpha)
\begin{bmatrix}\ddot\theta\\\ddot\alpha\end{bmatrix}
=
\begin{bmatrix}
\tau-D_r\dot\theta-2J_p\sin\alpha\cos\alpha\,\dot\theta\dot\alpha-m_p\ell L_r\sin\alpha\,\dot\alpha^2\\
-D_p\dot\alpha+J_p\sin\alpha\cos\alpha\,\dot\theta^2+m_pg\ell\sin\alpha
\end{bmatrix}.
$$

El voltaje actúa sobre la ecuación del brazo a través de $\tau$. El término de acoplamiento en $M$ transmite su efecto al péndulo. El integrador combina las aceleraciones calculadas con las velocidades para actualizar los cuatro estados. Python simula varios episodios en paralelo durante el entrenamiento. MATLAB usa la misma formulación para evaluar una política con pesos fijos.

### Parámetros de la planta

El Cuadro 2 recoge los valores de referencia de la consigna. La segunda columna numérica identifica los parámetros base que utilizaron el simulador de balance y el script MATLAB del controlador de referencia. Conviene mantener ambos conjuntos identificados al reproducir una prueba, porque las diferencias en resistencia y amortiguamiento cambian la predicción del movimiento.

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

### Referencia lineal y comprobación del equilibrio

El script `ProyectoControlFinal.m` construye las matrices $A$ y $B$ alrededor de la vertical superior, calcula $K$ con $Q=\mathrm{diag}(1,20,0.1,0.1)$ y $R=10$, y verifica los polos de $A-BK$. El regulador aplica $u=-Kx$ dentro de la región habilitada de balance. Esa referencia permite revisar la respuesta cerca del equilibrio y conservar un punto de comparación cuando se reemplaza la ley de control por la red neuronal.

## 4.2 Estimación de velocidades

Los encoders proporcionan posiciones angulares. En el entorno de balance se reproduce su cuantización con **2048 cuentas por vuelta** y se usa un **observador de tercer orden** para cada ángulo. El observador corrige sus estados con la diferencia entre la posición medida y la estimada, y entrega las velocidades que recibe la red. En la simulación de MATLAB, la planta se integra con RK4 y los observadores se actualizan con Euler a 2 ms.

La prueba de balance en simulación inicializa el observador con una velocidad consistente con el estado inicial. En el laboratorio esa velocidad debe estimarse a partir de la señal del encoder. Esta diferencia es relevante al capturar el péndulo, porque el supervisor necesita distinguir un paso rápido por la vertical de una entrada a baja velocidad en la región de balance.

### Modelo del observador

Para cada ángulo medido $y$, el observador usa los estados internos $\hat q$, $\hat v$ y $z$. La corrección depende del error entre la medición y la posición estimada.

$$
e=y-\hat q,\qquad
\dot{\hat q}=\hat v,\qquad
\dot{\hat v}=Le+mz,\qquad
\dot z=e-\beta z.
$$

El script coloca tres polos en $-100\ \mathrm{s}^{-1}$. De ahí se obtienen $\beta=300$, $L=30000$ y $m=-8000000$ en la parametrización del observador. Se usa la misma estructura por separado para el brazo y el péndulo. El cuantizador tiene una resolución de $2\pi/2048$ rad por cuenta, equivalente a unos **0.176°**. La estimación de velocidad evita usar directamente la diferencia entre dos conteos consecutivos como entrada al agente.

| Señal | Procedencia | Uso en el controlador |
|---|---|---|
| $\theta,\alpha$ | Encoders o cuantizador del modelo virtual | Posiciones en radianes, con $\alpha=0$ en la vertical invertida. |
| $\widehat{\dot\theta},\widehat{\dot\alpha}$ | Salidas de los dos observadores | Velocidades en rad/s que completan las cuatro entradas de balance. |
| $u_{\mathrm{DQN}}$ | Acción discreta seleccionada por la red | Voltaje solicitado antes del habilitador. |
| $V_m$ | Salida de la lógica de habilitación | Voltaje de entrada a la planta, que puede diferir de la acción solicitada. |

## 4.3 Entrenamiento y validación de la política de balance

El entrenamiento en Python produjo los pesos de la red, las escalas de entrada y la tabla de voltajes discretos. Al exportarlos al archivo `dqn_qube.mat` se conservaron el orden de los estados y el periodo de decisión. En MATLAB, `cargar_red_dqn` prepara la política para que seleccione el voltaje asociado al mayor valor de la red.

| Etapa | Archivo o modelo | Qué se comprobó |
|---|---|---|
| **A1. MATLAB** | `prueba_dqn_modelo_no_lineal.m` | Concordancia de las acciones exportadas para estados de prueba y respuesta del modelo ante una desviación inicial y una perturbación de velocidad. |
| **A2. Simulink** | `construir_entorno_pruebas.m` → `qube_dqn_pruebas.slx` | Ejecución en lazo cerrado sin QUARC, con planta simulada, encoders, observador y política discreta. |
| **Ensayo físico** | `conectar_al_simulink_original.m` → `qs3_dqn_ctrl.slx` | Conexión de la política a una copia del modelo del laboratorio, con los estados medidos y estimados del equipo. |

Las señales principales para comparar corridas son $\theta(t)$, $\alpha(t)$ y $V_m(t)$. La concordancia de acciones comprueba la exportación de la política. Las trayectorias y sus métricas comprueban el comportamiento del lazo.

### A1. Comprobación de inferencia y lazo cerrado en MATLAB

La exportación contiene **200 estados de prueba** y el voltaje seleccionado por Python para cada uno. La rutina A1 compara esas acciones con las de `politica_dqn` y `dqn_controller_block`. Se comprueba la normalización, el orden de las entradas, la evaluación de las capas y la asociación entre índice y voltaje. Después se ejecutan dos escenarios temporales en el modelo no lineal. En uno, el péndulo arranca a 10° de la vertical superior. En el otro, se parte del equilibrio y se introduce una perturbación de 2.5 rad/s en la velocidad del péndulo en $t=2$ s.

La prueba A1 usa RK4 para la planta y Euler para el observador. El voltaje queda retenido hasta la siguiente decisión. Esta prueba aísla la política y el estimador y permite detectar errores en la exportación antes de evaluar los bloques de Simulink.

### A2. Construcción del modelo virtual en Simulink

`construir_entorno_pruebas.m` genera `qube_dqn_pruebas.slx`. El subsistema **Qube simulado (sin QUARC)** integra la dinámica y entrega tanto el estado real del simulador como el estado observado. El resto del diagrama conecta la observación con la política y devuelve a la planta el voltaje habilitado.

![Vista previa del modelo A2 con la planta virtual, el retenedor, la red DQN, el habilitador y los registros]({{ '/assets/images/qube-simulink-a2.png' | relative_url }})

*Figura 4.1. Vista previa extraída de qube_dqn_pruebas.slx. Modelo de balance de la prueba A2 en Simulink.*

| Bloque de A2 | Función |
|---|---|
| **Qube simulado (sin QUARC)** | Contiene la dinámica no lineal, los encoders cuantizados y los observadores. |
| **ZOH agente** | Muestrea el estado observado con el periodo de 10 ms de la red. |
| **Controlador DQN y Rate Transition** | Evalúan la red y llevan su salida al paso de ejecución del modelo. |
| **Balance habilitado** | Selecciona la acción del agente dentro de la región angular del modelo de balance y aplica 0 V fuera de ella. |
| **x_log y u_log** | Registran el estado de la planta virtual y el voltaje que realmente entra al modelo. |

El archivo A2 usa `ode4` a paso fijo, con $T_s=2$ ms y una duración configurada de 10 s. El vector inicial por defecto es $x_0=[0,10^\circ,0,0]^T$, con los ángulos internamente en radianes. A2 reproduce los bloques del lazo y su habilitación. A1 y A2 se comparan documentando el integrador, la condición inicial y el origen de cada señal.

## 4.4 Transferencia al QUBE-Servo 3

La copia de laboratorio conserva QUARC, los encoders, los observadores y el habilitador angular del modelo de balance. El bloque LQR se sustituyó por la política DQN. Un retenedor fija el periodo de decisión y un bloque de transición de tasa lleva la salida al paso de ejecución del modelo. El LQR original se conservó como referencia experimental.

En el ensayo físico inicial, el péndulo se colocó manualmente cerca de la vertical invertida. Con el DQN, el brazo osciló rápidamente y el equilibrio no se sostuvo. El diagnóstico requiere comparar las señales estimadas y el voltaje aplicado, y revisar los transitorios del observador, la saturación y el tiempo real de ejecución. La evidencia disponible no establece una causa única.

La señal $X$ de **Qube With Pendulum** se conecta directamente al bloque que muestrea las entradas del DQN. El camino original del LQR incluía una resta respecto a la referencia seguida de una ganancia. En la copia neuronal se retiró ese camino para que el signo de $X$ coincidiera con la convención de entrenamiento. La salida de la red se dirige al selector de balance después de la transición de tasa. Esta conexión conserva la diferencia entre **solicitar un voltaje** y **habilitarlo en la salida del modelo**.

Para comparar un ensayo físico con la simulación interesa registrar el vector $X$ que recibió la red, la acción seleccionada, la señal de habilitación y el voltaje aplicado. Si el voltaje alterna entre acciones aun cuando el ángulo cambia poco, el registro de las velocidades estimadas ayuda a distinguir una decisión sensible al estado de un corte de la lógica de habilitación.

## 4.5 Integración de levantamiento y balance

La extensión de simulación usa dos políticas. El agente de *swing-up* lleva el péndulo desde la posición colgante hacia la región de captura. El supervisor selecciona la política de balance cuando el ángulo y la velocidad angular del péndulo cumplen las condiciones de captura y el brazo permanece dentro de su margen de movimiento. El habilitador angular del controlador de balance de laboratorio no cumple la función de ese supervisor.

Para validar la secuencia conjunta se requiere registrar el instante de captura, el modo activo, $\theta(t)$, $\alpha(t)$, las velocidades estimadas y $V_m(t)$. La transferencia física documentada corresponde al agente de balance. La validación de la secuencia completa en el QUBE-Servo 3 queda pendiente.

El diseño del modelo conjunto conserva un estado físico común y construye dos observaciones a partir de él. El agente de levantamiento recibe una codificación periódica del ángulo del péndulo. El agente de balance recibe $\alpha$ referido a la vertical invertida. La conmutación cambia la política que calcula $V_m$ y conserva el estado de la planta y de los observadores durante la transición.

[Continuar a Agentes DQN]({{ '/dqn.html' | relative_url }})
