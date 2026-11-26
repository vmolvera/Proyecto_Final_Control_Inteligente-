---
layout: default
title: "5. Diseño de agentes y robustez"
nav_order: 6
---

# 5. Diseño de los agentes DQN y análisis de robustez

El problema de control se divide en dos tareas con condiciones iniciales distintas. El agente de **balance** actúa cerca de la vertical invertida. El agente de **levantamiento** (*swing-up*) debe llegar desde la posición colgante a una región donde el agente de balance pueda tomar el control. Cada tarea necesita su propio criterio de éxito.

## 5.1 Formulación del problema de aprendizaje

En cada decisión, el agente recibe una observación, elige un voltaje discreto y obtiene una recompensa después de que avanza la planta. El estado dinámico completo incluye los dos ángulos y sus velocidades. Para la inferencia, las velocidades se estiman y los ángulos proceden de encoders. La siguiente tabla describe el MDP implementado para balance y la formulación documentada para la extensión de levantamiento.

| Elemento | DQN de balance | DQN de levantamiento |
|---|---|---|
| Condición inicial | Ángulos y velocidades variables cerca de la vertical invertida. | Péndulo cerca de la posición colgante, $\alpha\approx\pm\pi$. |
| Observación | $[\theta,\alpha,\widehat{\dot\theta},\widehat{\dot\alpha}]$. | $[\theta,\sin\alpha,\cos\alpha,\widehat{\dot\theta},\widehat{\dot\alpha}]$. El seno y el coseno mantienen continua la representación al cruzar $\pm\pi$. |
| Acciones | 11 voltajes discretos (−10, −6, −3, −1.5, −0.5, 0, 0.5, 1.5, 3, 6 y 10 V) en el entrenamiento. | 9 acciones discretas entre −3 y +3 V en la configuración documentada para simulación. |
| Recompensa | Favorece el equilibrio y penaliza el error angular, las velocidades y el esfuerzo de control. | El diseño busca premiar el avance hacia la vertical y la captura a baja velocidad, penalizando la excursión del brazo y el esfuerzo. Los coeficientes de una política final entrenada no están verificados. |
| Término | Fallo si el péndulo supera 25°, el brazo supera 120° en valor absoluto o el estado deja de ser finito. El episodio se trunca a los 5 s. | La captura habilita la transición a balance. Para evaluar el levantamiento por separado, se distingue la captura válida del vencimiento del horizonte o de la salida de los límites del simulador. Los límites de entrenamiento finales están pendientes de confirmar. |

Los límites de esta tabla corresponden a la formulación de simulación. El habilitador del montaje físico de balance es parte de la implementación descrita en la [sección 4]({{ '/implementacion.html' | relative_url }}).

### Recompensa de balance

El entorno de balance calcula el costo a partir del estado del simulador y el voltaje aplicado.

$$C_k=\theta_k^2+20\alpha_k^2+0.05\dot\theta_k^2+0.05\dot\alpha_k^2+0.002V_{m,k}^2.$$

En los pasos ordinarios se usa $r_k=1-\min(2,C_k)$. Al terminar por fallo se asigna una recompensa de $-10$. El peso mayor de $\alpha$ prioriza mantener el péndulo invertido. El término de $\theta$ mantiene el brazo cerca de la referencia y el del voltaje penaliza esfuerzos elevados. La validación en Python mide éxito cuando el episodio llega al horizonte sin caída y en el último 10 % de la prueba mantiene $\lvert\alpha\rvert<3^\circ$ y $\lvert\theta\rvert<15^\circ$.

## 5.2 Arquitectura, sintonía y estabilidad del aprendizaje

La red de balance tiene **4 entradas, dos capas ocultas de 128 unidades ReLU y 11 salidas**. Cada salida estima el valor de una acción. Double DQN usa la red en línea para seleccionar la acción siguiente y la red objetivo para estimar su valor. La observación se escala antes de entrar en la red y las transiciones se almacenan en una memoria de experiencias para entrenar con lotes de episodios diferentes.

| Hiperparámetro | Configuración exportada de balance |
|---|---|
| Factor de descuento $\gamma$ | 0.99 |
| Tasa inicial de aprendizaje | $3\times10^{-4}$, con Adam y reducción cosenoidal |
| Exploración $\epsilon$ | De 1 a 0.05 en 8 000 pasos vectorizados |
| Tamaño de lote | 256 transiciones |
| Retorno de varios pasos | 8 decisiones |
| Actualización de la red objetivo | Copia de pesos cada 500 actualizaciones de gradiente |
| Memoria y arranque | 400 000 transiciones de capacidad y 5 000 antes de actualizar la red |
| Presupuesto y selección de política | 60 000 pasos en 16 entornos paralelos, con validación cada 2 000 pasos |

El código de entrenamiento documenta que se observaron valores Q divergentes con actualización suave y muestreo fino. La configuración exportada combina copias periódicas de la red objetivo, retorno de varios pasos, pérdida de Huber, acotamiento de objetivos y recorte de la norma del gradiente a 10. La selección de pesos se hizo con la tasa de éxito en validación. El archivo de configuración conserva los valores de la corrida exportada. El historial disponible no permite atribuir el desempeño a un cambio aislado de hiperparámetros.

En levantamiento, la configuración documentada propone Double DQN, memoria de experiencias, retorno de varios pasos, red objetivo y pérdida de Huber. El currículo de condiciones iniciales tiene como fin facilitar el aprendizaje antes de evaluar la política desde la posición colgante. El ajuste debe juzgarse por la tasa de capturas desde esa posición y por el balance posterior a la conmutación. La configuración final de hiperparámetros, la curva de entrenamiento y los pesos de levantamiento todavía no tienen una corrida verificable disponible para esta sección.

## 5.3 Región de captura y evaluación de los dos agentes

El criterio de captura combina ángulo cercano a la vertical invertida, velocidad angular baja y margen de movimiento del brazo. El supervisor entrega el control a una sola política a la vez. Para interpretar el comportamiento completo se miden por separado la fracción de episodios que llegan a la región de captura, el tiempo hasta la primera captura y la fracción que mantienen el equilibrio después de la transición. Una captura por sí sola mide el levantamiento. El tiempo posterior en balance mide si la transición fue útil.

## 5.4 Análisis de robustez en simulación
{: #robustez-simulacion }

### Ensayo requerido para el Cuadro 2

El ensayo compara el desempeño de los agentes entrenados con los parámetros nominales del Cuadro 2 frente a perturbaciones de hasta **±2 %** en el simulador. Para cada parámetro $p$ se usa $p=p_0(1+\delta)$, con $-0.02\leq\delta\leq0.02$. La línea base fija todos los parámetros en $p_0$. Durante la evaluación se congelan los pesos y se conservan el muestreo, la estimación de velocidades, las condiciones iniciales y las semillas correspondientes a cada comparación.

1. **Variación individual.** Evaluar −2 % y +2 % de cada parámetro, manteniendo los demás en su valor nominal. Incluir resistencia, constante de motor, masas, longitudes, amortiguamientos y gravedad. Recalcular las inercias si cambian las dimensiones o las masas.
2. **Variación conjunta.** Muestrear los parámetros dentro del intervalo de ±2 % y usar las mismas condiciones iniciales que en la línea base para comparar cambios de desempeño.
3. **Balance aislado.** Iniciar cerca de la vertical superior y registrar tasa de éxito, error angular RMS, excursión del brazo y esfuerzo de control.
4. **Levantamiento y secuencia conjunta.** Iniciar cerca de la posición colgante y registrar capturas, tiempo hasta la captura y éxito posterior del balance. Guardar las fallas antes y después de la transferencia para identificar qué tarea degradó el resultado.

### Evidencia disponible

| Evaluación | Evidencia documentada | Alcance |
|---|---|---|
| DQN de balance con los pesos exportados | **98.8 %** en validación de Python y **99.6 %** reportado en el Monte Carlo de MATLAB de 500 casos con variación de **±15 %**. | El entrenamiento disponible aplicó aleatorización de ±10 % alrededor de los valores base del simulador, con $g$ fija. Los valores base difieren del Cuadro 2 en varios parámetros y el Monte Carlo de MATLAB usa su propio criterio de éxito. |
| DQN de balance entrenado en el nominal del Cuadro 2 y evaluado a ±2 % | Sin corrida final verificable asociada a los pesos documentados en esta sección. | Queda pendiente reportar la comparación nominal, individual y conjunta con los mismos pesos. |
| DQN de levantamiento y transición a balance a ±2 % | Se dispone del diseño de evaluación. Falta una serie verificable de episodios con pesos, condiciones iniciales y registros de modo. | Las tasas de captura y de balance posterior quedan pendientes. |

Los porcentajes disponibles corresponden a configuraciones de evaluación distintas. La comparación solicitada requiere resultados por agente y por escenario con los parámetros, los pesos y el criterio de éxito identificados en cada corrida.
