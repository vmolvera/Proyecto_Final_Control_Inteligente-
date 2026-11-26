---
layout: default
title: "6. Resultados"
nav_order: 7
---

# 6. Resultados

El DQN sostuvo el balance en los dos escenarios temporales de la prueba A1 en simulación. En el QUBE-Servo 3, el DQN de balance mantiene el péndulo en la posición invertida. El LQR mantuvo el péndulo invertido y sirvió como referencia experimental. Las siguientes pruebas permiten examinar qué parte del desempeño se observó en cada etapa.

## 6.1 Verificación de la política y resultados de simulación

| Prueba | Resultado | Qué se evaluó |
|---|---|---|
| Inferencia con los pesos exportados | **200 de 200** acciones coincidentes con el archivo de referencia. | Consistencia de la normalización, las capas de la red y la asignación entre índice y voltaje. |
| Validación durante el entrenamiento en Python | **98.8 %** de éxito registrado en el archivo de configuración de la red exportada. | Desempeño en el conjunto de validación del entrenamiento. |
| Monte Carlo de referencia en MATLAB | **99.6 %** de éxito reportado en 500 casos con variaciones paramétricas de **±15 %**. | Comportamiento en la configuración original del ensayo, con condiciones iniciales variables y ruido en las velocidades estimadas. |
| A2 en Simulink | El modelo virtual ejecutó la política en lazo cerrado con el observador y el habilitador de balance. | Integración de bloques. Las métricas temporales de la tabla de la sección 6.2 corresponden a A1. |

La validación de Python y el Monte Carlo de MATLAB usan configuraciones y criterios de éxito propios. La concordancia de 200 acciones verifica la inferencia para entradas dadas. La estabilidad se examina con las trayectorias completas.

## 6.2 Respuestas temporales del DQN de balance

Se analizaron los dos escenarios de la prueba A1. Se conservaron los pesos de **dqn_qube.mat**, el modelo no lineal con los parámetros base de entrenamiento, la cuantización de los encoders y el observador. La planta se integró a 2 ms y el agente seleccionó un voltaje cada 10 ms durante 6 s.

### 6.2.1 Recuperación desde una desviación de 10°

El péndulo inició a $10^\circ$ de la vertical invertida, con el brazo centrado y ambas velocidades nulas. El controlador corrigió el ángulo del péndulo con una excursión transitoria del brazo de aproximadamente **22.62°**. El péndulo se mantuvo cerca de la vertical después del transitorio, mientras que el brazo conservó un pequeño desplazamiento respecto al centro.

![Prueba A1 desde diez grados. Trazas de ángulo de péndulo, ángulo de brazo y voltaje del motor]({{ '/assets/images/dqn-a1-desviacion.png' | relative_url }})

*Figura 6.1. Respuesta simulada de balance desde una desviación de 10°. Gráfica del ensayo A1.*

### 6.2.2 Recuperación ante una perturbación de velocidad

El sistema inició en el equilibrio invertido. En $t=2$ s se añadió un incremento de **2.5 rad/s** a $\dot\alpha$. El DQN recuperó el balance con una excursión del brazo mayor que en el ensayo anterior. En los dos casos, los cambios escalonados de $V_m$ corresponden a la selección entre niveles discretos de voltaje.

![Prueba A1 con perturbación a los dos segundos. Trazas de ambos ángulos y del voltaje de control]({{ '/assets/images/dqn-a1-perturbacion.png' | relative_url }})

*Figura 6.2. Respuesta simulada a un incremento de velocidad angular a los 2 s. Gráfica del ensayo A1.*

| Métrica | Desviación inicial de 10° | Perturbación a los 2 s |
|---|---:|---:|
| Máximo absoluto del ángulo del péndulo | 10.00° | 6.52° |
| Máximo absoluto del ángulo del brazo | 22.62° | 36.42° |
| RMS del ángulo del péndulo durante los 6 s | 1.06° | 1.31° |
| Máximo absoluto de voltaje | 6 V | 6 V |
| Tiempo aproximado hasta permanecer en la banda de balance | 0.40 s desde el arranque | 0.66 s desde la perturbación |

Los valores de la tabla proceden de una reproducción numérica del lazo A1. Para medir la recuperación se identificó la entrada a la banda definida por $\lvert\alpha\rvert<3^\circ$ y $\lvert\theta\rvert<15^\circ$ a partir de la cual el sistema permaneció en ella hasta terminar la corrida.

## 6.3 Comparación en el QUBE-Servo 3

| Controlador | Observación en el laboratorio | Alcance de la evidencia |
|---|---|---|
| **LQR de referencia** | Mantuvo el péndulo en la posición invertida. | Referencia física de balance. |
| **DQN de balance** | El DQN mantuvo el péndulo en la posición invertida en el QUBE-Servo 3. | Balance observado en el equipo físico. |
| **Swing-up y balance** | La transición se documentó como parte del diseño del supervisor. | No se dispone de una serie verificable de capturas y tiempos de balance posterior con los dos agentes. |

La comparación física disponible es cualitativa. Sin registros sincronizados de $\theta$, $\alpha$, las velocidades estimadas y $V_m$ para ambos controladores bajo condiciones equivalentes, queda pendiente calcular diferencias de RMS o tiempo de recuperación en laboratorio. Los transitorios del observador, la saturación, los cambios discretos de voltaje y los retardos son hipótesis que requieren contrastarse con esas señales.

## 6.4 Análisis complementario de robustez en simulación
{: #robustez-simulacion }

### Protocolo de sensibilidad a ±2 %

Se realizó un barrido numérico con los **pesos exportados de balance fijos**. Se evaluaron dos conjuntos de referencia, los parámetros base del simulador y los valores del **Cuadro 2** indicados en [Implementación]({{ '/implementacion.html' | relative_url }}#modelo-no-lineal). Para cada conjunto se evaluó el caso sin variaciones, los extremos de −2 % y +2 % de cada uno de los nueve parámetros por separado y un escenario de variación conjunta dentro del intervalo. Se incluyó la gravedad en la evaluación y se recalcularon las inercias cuando cambiaron las masas o longitudes según la formulación del simulador de balance.

Todos los escenarios reutilizaron la misma malla de **81 estados iniciales**, formada por tres niveles de cada componente. El brazo partió de −30°, 0° o +30°, el péndulo de −12°, 0° o +12°, y las velocidades de −1, 0 o +1 rad/s para el brazo y de −2, 0 o +2 rad/s para el péndulo. El escenario conjunto utilizó perturbaciones uniformes independientes con semilla 2026 y los mismos factores relativos para ambas referencias. En total se simularon **3 240 trayectorias** de 5 s.

La simulación conservó la cuantización y la estimación de velocidades, con la acción retenida cada 10 ms y la integración a 2 ms. Se omitió el ruido adicional para aislar la sensibilidad paramétrica. Se contó como éxito si $\lvert\alpha\rvert$ permaneció por debajo de 60° durante toda la corrida y, en los últimos 0.5 s, se cumplieron simultáneamente $\lvert\alpha\rvert<3^\circ$ y $\lvert\theta\rvert<15^\circ$. El ensayo reproduce el lazo numérico de A1. El habilitador angular del montaje de laboratorio pertenece al modelo descrito en Implementación.

### Resultados del barrido

| Referencia de evaluación | Caso | Éxitos | RMS medio del péndulo en episodios exitosos |
|---|---|---:|---:|
| Base del simulador | Sin variaciones | 74/81 (91.4 %) | 1.442° |
| Base del simulador | Variación conjunta de hasta ±2 % | 74/81 (91.4 %) | 1.455° |
| Valores del Cuadro 2 | Sin variaciones | 69/81 (85.2 %) | 1.592° |
| Valores del Cuadro 2 | Variación conjunta de hasta ±2 % | 69/81 (85.2 %) | 1.602° |

| Parámetro variado individualmente alrededor del Cuadro 2 | Éxitos con −2 % | Éxitos con +2 % |
|---|---:|---:|
| Resistencia de armadura $R_m$ | 69/81 | 69/81 |
| Constante del motor $k_m$ | 69/81 | 69/81 |
| Masa del brazo $m_r$ | 70/81 | 70/81 |
| Longitud del brazo $L_r$ | 69/81 | 70/81 |
| Amortiguamiento del brazo $D_r$ | 70/81 | 70/81 |
| Masa del péndulo $m_p$ | 69/81 | 70/81 |
| Longitud del péndulo $L_p$ | 71/81 | 70/81 |
| Amortiguamiento del péndulo $D_p$ | 71/81 | 69/81 |
| Gravedad $g$ | 70/81 | 70/81 |

El barrido individual produjo entre **74 y 75 éxitos** alrededor de la base del simulador y entre **69 y 71** alrededor del Cuadro 2. La diferencia entre los dos casos base fue de cinco éxitos, equivalente a **6.2 puntos porcentuales** en esta malla. En el ensayo conjunto se conservaron los mismos casos exitosos de cada referencia, con un ligero aumento del RMS del péndulo. El RMS de la tabla se calcula sobre los 5 s de cada episodio exitoso y luego se promedia entre dichos episodios. El recuento depende de las condiciones iniciales y del criterio de éxito.

[Datos del barrido por escenario (CSV)]({{ '/assets/images/dqn-sensibilidad-2pct.csv' | relative_url }})

### Alcance para levantamiento y balance

El barrido usa el agente de balance ya entrenado alrededor de la base del simulador con aleatorización paramétrica. Al evaluar en el Cuadro 2 se sustituyeron los valores de sus parámetros dentro de la misma formulación dinámica. Para completar el ensayo formal de la asignatura falta evaluar un agente entrenado específicamente con los parámetros nominales del Cuadro 2 y conservar sus pesos durante las variaciones.

Para extender la evaluación al *swing-up* se requieren pesos de levantamiento verificables y trazas del modo del supervisor. Los indicadores son la tasa y el tiempo de captura desde la posición colgante, la velocidad de llegada y la proporción de episodios que conservan el balance después de conmutar. La evidencia actual permite cuantificar la sensibilidad del **balance simulado**. La sensibilidad de la secuencia de dos agentes queda pendiente.
