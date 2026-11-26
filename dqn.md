---
layout: default
title: "5. Agentes DQN"
nav_order: 6
---

# 5. Agentes DQN

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

### Observación, acción y transición

El índice de acción se interpreta mediante una tabla fija de voltajes. Los niveles de balance tienen mayor resolución cerca de cero, donde la política necesita realizar correcciones pequeñas, y conservan niveles de mayor amplitud para responder a desviaciones más grandes en simulación. En cada decisión se mantiene el voltaje durante cinco pasos de integración. La transición se guarda con la observación siguiente y con el indicador que distingue una falla del término por tiempo.

El estado interno del simulador contiene las velocidades reales. La observación de la red contiene las velocidades estimadas. Por eso la recompensa puede calcularse con el estado simulado mientras la política aprende a decidir con señales de características similares a las del montaje. En los reinicios de balance se varían las posiciones y velocidades iniciales cerca del equilibrio invertido y se inicializan los estados del observador de forma consistente con esa condición.

### Recompensa de balance

El entorno de balance calcula el costo a partir del estado del simulador y el voltaje aplicado.

$$C_k=\theta_k^2+20\alpha_k^2+0.05\dot\theta_k^2+0.05\dot\alpha_k^2+0.002V_{m,k}^2.$$

En los pasos ordinarios se usa $r_k=1-\min(2,C_k)$. Al terminar por fallo se asigna una recompensa de $-10$. El peso mayor de $\alpha$ prioriza mantener el péndulo invertido. El término de $\theta$ mantiene el brazo cerca de la referencia y el del voltaje penaliza esfuerzos elevados. La validación en Python mide éxito cuando el episodio llega al horizonte sin caída y en el último 10 % de la prueba mantiene $\lvert\alpha\rvert<3^\circ$ y $\lvert\theta\rvert<15^\circ$.

## 5.2 Arquitectura, sintonía y estabilidad del aprendizaje

La red de balance tiene **4 entradas, dos capas ocultas de 128 unidades ReLU y 11 salidas**. Cada salida estima el valor de una acción. Double DQN usa la red en línea para seleccionar la acción siguiente y la red objetivo para estimar su valor. La observación se escala antes de entrar en la red y las transiciones se almacenan en una memoria de experiencias para entrenar con lotes de episodios diferentes.

### Normalización e inferencia

Las cuatro entradas de balance se dividen por las escalas $[1,\,0.3,\,4,\,8]$ en el orden de observación. Las posiciones se expresan en radianes y las velocidades en rad/s. Esta escala es la misma en Python y MATLAB.

| Capa | Entrada → salida | Operación |
|---|---|---|
| Primera oculta | 4 → 128 | Transformación afín y activación ReLU. |
| Segunda oculta | 128 → 128 | Transformación afín y activación ReLU. |
| Salida | 128 → 11 | Valores $Q$ en el orden de la tabla de acciones. |

Durante la inferencia, la red recibe la observación normalizada, calcula los once valores y selecciona el índice de mayor $Q$. La implementación MATLAB aplica las matrices y sesgos exportados y recupera el voltaje de ese mismo índice. Conservar estas correspondencias evita que una red con pesos correctos produzca comandos equivocados por un cambio en el orden de las señales o de las acciones.

### Objetivo de entrenamiento

La memoria almacena transiciones agregadas de hasta ocho decisiones. Si $m$ es el número de decisiones acumuladas antes del corte y $d=1$ indica una falla terminal, el objetivo de entrenamiento es

$$
y_k=\sum_{i=0}^{m-1}\gamma^i r_{k+i}
+(1-d)\gamma^m
Q_{\mathrm{obj}}\!\left(o_{k+m},\arg\max_a Q_{\mathrm{online}}(o_{k+m},a)\right).
$$

La red minimiza la pérdida de Huber entre $Q_{\mathrm{online}}(o_k,a_k)$ y el objetivo acotado. Un episodio terminado por falla elimina el término futuro. Si el corte se debe al horizonte de simulación, se conserva la observación previa al reinicio para calcular la transición correctamente.

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

### Criterios para la sintonía de balance

1. **Exploración y tamaño de lote.** La exploración comienza con una probabilidad alta de acciones aleatorias y disminuye a medida que se reúne experiencia. El entrenamiento aplaza las actualizaciones hasta disponer de 5 000 transiciones.
2. **Estabilidad de las actualizaciones.** La red objetivo se actualiza por copia periódica. La pérdida de Huber y el recorte del gradiente limitan el efecto de errores grandes en transiciones cercanas a una falla.
3. **Alcance temporal de la recompensa.** El retorno de ocho decisiones incorpora 80 ms de respuesta a la actualización. Así, la red puede asociar una acción con una consecuencia que aparece varios pasos después.
4. **Elección del punto de guardado.** La política se valida sin acciones aleatorias. Se conserva el punto de entrenamiento con mayor tasa de éxito, calculada con los límites de balance definidos en el apartado 5.1.

## 5.3 Agente de levantamiento autónomo

### Representación del movimiento y objetivo de aprendizaje

Desde la posición colgante el movimiento debe generar energía suficiente para alcanzar la parte superior y entrar con velocidad angular reducida. Un premio basado únicamente en la proximidad a la vertical podría favorecer que el péndulo cruce esa zona demasiado rápido. La formulación de levantamiento considera el avance angular y la calidad de la llegada, además de la excursión del brazo y el voltaje utilizado.

La red de levantamiento utiliza $\sin\alpha$ y $\cos\alpha$ como entradas separadas. Las posiciones a ambos lados de $\pm\pi$ quedan próximas en el espacio de observación, lo que evita introducir un salto artificial al pasar por la posición colgante. El supervisor, en cambio, compara el ángulo respecto de la vertical superior y la velocidad con la región de captura.

### Entrenamiento previsto y criterios de ajuste

La configuración documentada del entorno virtual plantea Double DQN, memoria de experiencias, retornos de varios pasos, red objetivo y pérdida de Huber. El currículo modifica las condiciones iniciales para trabajar primero con trayectorias donde sea más frecuente llegar a la región de captura. La evaluación de levantamiento parte de la posición colgante y utiliza condiciones iniciales separadas del entrenamiento.

El ajuste se evalúa con la tasa de capturas válidas, el tiempo hasta la primera captura y la velocidad angular en ese instante. Los pesos de una política final de levantamiento, sus coeficientes de recompensa y un registro completo de sintonía siguen sin verificarse. Los valores de la red de balance documentados arriba corresponden a esa red específicamente.

## 5.4 Supervisor de transferencia

El supervisor combina tres condiciones para transferir el control: ángulo del péndulo cercano a la vertical invertida, velocidades angulares bajas y posición del brazo dentro del margen de captura. La implementación virtual documentada plantea umbrales de entrada más estrechos que el umbral angular de salida. Esa histéresis reduce la posibilidad de alternar entre agentes en muestras consecutivas.

| Estado del supervisor | Decisión |
|---|---|
| Levantamiento | Aplicar únicamente la acción del agente de *swing-up*. |
| Entrada a la región de captura | Cambiar a la política de balance sin reiniciar la planta ni los observadores. |
| Balance | Aplicar únicamente el voltaje solicitado por la política de estabilización, mientras se cumplan las condiciones del modo. |
| Pérdida de captura en el entorno virtual | Registrar la salida de balance y aplicar la lógica de retorno o parada configurada en la simulación. |

Para interpretar una corrida conjunta se distinguen el tiempo hasta la captura, la velocidad de llegada y el tiempo de balance posterior. Registrar el modo y el voltaje en cada muestra permite asociar una falla al levantamiento, a la transferencia o a la estabilización. La secuencia conjunta queda pendiente de validación física.
